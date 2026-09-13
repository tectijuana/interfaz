#!/bin/bash
# ==========================================
# Script: ec2-interfaz.sh
# Autor: MC. René Solis R. @IoTeacher
# Descripción: Menú de gestión de nodos EC2 ARM64 para los cursos del docente
#              (Lenguajes de Interfaz + Programación Lógica y Funcional).
#              Antes lanzaba una sola instancia a ciegas; ahora también
#              permite ver qué máquinas quedaron prendidas y terminarlas,
#              para que el alumno no pierda de vista su gasto en el Learner Lab.
# Uso:         ejecutar dentro de AWS CloudShell (AWS Academy Learner Lab)
# ==========================================

export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"
KEY_NAME="${KEY_NAME:-llavesita}"

# ----- helpers -----
need() {
  local nombre="$1" valor="$2"
  if [ -z "$valor" ] || [ "$valor" = "None" ]; then
    echo "❌ No se pudo resolver: $nombre (valor='$valor')" >&2
    return 1
  fi
  echo "   $nombre = $valor"
}

# autorizar una regla de ingress solo si no existe ya (idempotente y auditable).
# NO usamos `aws ec2 describe-security-group-rules`: el AWS CLI de la CloudShell
# del Learner Lab es viejo y no la conoce ("Invalid choice: 'describe-security-group-rules'").
# En su lugar intentamos crear la regla e interpretamos InvalidPermission.Duplicate
# como "ya existía".
autorizar_ingress() {
  local sg="$1" proto="$2" desde="$3" hasta="$4" origen="$5" desc="$6"
  local origen_flag puerto
  if [[ "$origen" == sg-* ]]; then
    origen_flag=(--source-group "$origen")
  else
    origen_flag=(--cidr "$origen")
  fi
  puerto="$( [ "$desde" = "$hasta" ] && echo "$desde" || echo "$desde-$hasta" )"

  local out
  if out=$(aws ec2 authorize-security-group-ingress \
            --group-id "$sg" --protocol "$proto" --port "$puerto" \
            "${origen_flag[@]}" 2>&1); then
    echo "   ➕ agregada    $proto $desde-$hasta  <- $origen   ($desc)"
  elif echo "$out" | grep -q "InvalidPermission.Duplicate"; then
    echo "   ✅ ya existe  $proto $desde-$hasta  <- $origen"
  else
    echo "   ❌ error autorizando $proto $desde-$hasta <- $origen" >&2
    echo "$out" >&2
    return 1
  fi
}

asegurar_key() {
  if aws ec2 describe-key-pairs --key-names "$KEY_NAME" >/dev/null 2>&1; then
    if [ -f "${KEY_NAME}.pem" ]; then
      echo "   ✅ Key '$KEY_NAME' existe en AWS y el .pem local está presente."
    else
      echo "   ⚠️  Key '$KEY_NAME' existe en AWS pero falta ${KEY_NAME}.pem local."
      echo "      Recreando la key (instancias existentes conservan su acceso actual;"
      echo "      las NUEVAS usarán la key nueva)."
      aws ec2 delete-key-pair --key-name "$KEY_NAME" >/dev/null
      aws ec2 create-key-pair --key-name "$KEY_NAME" \
        --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
      chmod 400 "${KEY_NAME}.pem"
      echo "   🆕 Key recreada y guardada en ${KEY_NAME}.pem"
    fi
  else
    echo "   🆕 Creando key '$KEY_NAME'..."
    aws ec2 create-key-pair --key-name "$KEY_NAME" \
      --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
    chmod 400 "${KEY_NAME}.pem"
    echo "   Guardada en ${KEY_NAME}.pem"
  fi
}

asegurar_red() {
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" \
    --query "Vpcs[0].VpcId" --output text)
  need "VPC default" "$VPC_ID" || return 1
  SUBNET_ID=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=default-for-az,Values=true" \
    --query "Subnets[0].SubnetId" --output text)
  need "Subnet default" "$SUBNET_ID" || return 1
}

asegurar_sg() {
  local sg_name="$1" desc="$2"
  SG_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$sg_name" "Name=vpc-id,Values=$VPC_ID" \
    --query 'SecurityGroups[0].GroupId' --output text)
  if [ "$SG_ID" = "None" ] || [ -z "$SG_ID" ]; then
    SG_ID=$(aws ec2 create-security-group \
      --group-name "$sg_name" --description "$desc" --vpc-id "$VPC_ID" \
      --query 'GroupId' --output text)
    echo "   🆕 Security group creado."
  fi
  need "Security group" "$SG_ID"
}

guarda_duplicados() {
  local instance_name="$1"
  local ya
  ya=$(aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=$instance_name" \
              "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query "Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]" \
    --output text)
  if [ -n "$ya" ]; then
    echo "⚠️  Ya existe una instancia con Name=$instance_name:"
    echo "$ya" | sed 's/^/     /'
    if [ "${FORCE:-0}" != "1" ]; then
      read -r -p "   ¿Lanzar OTRA de todas formas? (escribe 'si' para continuar) " ok
      [ "$ok" = "si" ] || { echo "   Abortado por el usuario."; return 1; }
    fi
  else
    echo "   OK, no hay instancias previas con ese nombre."
  fi
}

# ----- 1) Crear EC2 para ARM Assembly (Lenguajes de Interfaz) -----
crear_arm_assembly() {
  echo
  echo "===== Crear EC2 — Lenguajes de Interfaz (ARM Assembly) ====="
  local SG_NAME="arm64-ssh-group"
  local DESC="Leng. Ensamblador para ARM64"
  local INSTANCE_TYPE="${INSTANCE_TYPE:-t4g.micro}"
  local INSTANCE_NAME="${INSTANCE_NAME:-Curso-Interfaz}"
  local TAGS="{Key=Name,Value=$INSTANCE_NAME},{Key=Curso,Value=SCC-1014-Interfaz},{Key=Proyecto,Value=lenguajes-de-interfaz}"

  echo "   INSTANCE_TYPE = $INSTANCE_TYPE"
  echo "   INSTANCE_NAME = $INSTANCE_NAME"

  guarda_duplicados "$INSTANCE_NAME" || return 1

  echo "===== Key Pair =====";        asegurar_key || return 1
  echo "===== Red =====";             asegurar_red || return 1
  echo "===== Security Group =====";  asegurar_sg "$SG_NAME" "$DESC" || return 1

  echo "===== Reglas de entrada ====="
  autorizar_ingress "$SG_ID" tcp 22 22 "0.0.0.0/0" "SSH" || return 1

  echo "===== AMI Ubuntu ARM64 ====="
  local AMI_ID
  AMI_ID=$(aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*" \
              "Name=state,Values=available" \
    --query "sort_by(Images, &CreationDate)[-1].ImageId" \
    --output text)
  need "AMI" "$AMI_ID" || return 1

  echo "===== Lanzar instancia ====="
  local INSTANCE_ID
  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --subnet-id "$SUBNET_ID" \
    --associate-public-ip-address \
    --tag-specifications "ResourceType=instance,Tags=[$TAGS]" \
    --query 'Instances[0].InstanceId' \
    --output text)
  need "InstanceId" "$INSTANCE_ID" || return 1

  echo "===== Esperando instance-running ====="
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

  local PUBLIC_IP
  PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)

  echo
  echo "   InstanceId : $INSTANCE_ID"
  echo "   IP pública : $PUBLIC_IP"
  echo "   SSH        : ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"
}

# ----- 2) Crear EC2 para Programación Lógica y Funcional -----
crear_prog_funcional() {
  echo
  echo "===== Crear EC2 — Programación Lógica y Funcional ====="
  local SG_NAME="arm64-ssh-group"
  local DESC="Programacion Logica y Funcional - ARM64"
  local INSTANCE_TYPE="${INSTANCE_TYPE:-t4g.large}"
  local INSTANCE_NAME="${INSTANCE_NAME:-Curso-PLF}"
  local ROOT_GB="${ROOT_GB:-30}"
  local SWAP_GB="${SWAP_GB:-2}"
  local TAGS="{Key=Name,Value=$INSTANCE_NAME},{Key=Curso,Value=ISC-2006-PLF},{Key=Proyecto,Value=programacion-logica-y-funcional}"

  echo "   INSTANCE_TYPE     = $INSTANCE_TYPE"
  echo "   INSTANCE_NAME     = $INSTANCE_NAME"
  echo "   ROOT_GB / SWAP_GB = ${ROOT_GB} / ${SWAP_GB}"

  guarda_duplicados "$INSTANCE_NAME" || return 1

  echo "===== Key Pair =====";        asegurar_key || return 1
  echo "===== Red =====";             asegurar_red || return 1
  echo "===== Security Group =====";  asegurar_sg "$SG_NAME" "$DESC" || return 1

  echo "===== Reglas de entrada ====="
  autorizar_ingress "$SG_ID" tcp 22 22 "0.0.0.0/0" "SSH" || return 1
  autorizar_ingress "$SG_ID" tcp 4369 4369 "$SG_ID" "EPMD (Erlang Port Mapper Daemon)" || return 1
  autorizar_ingress "$SG_ID" tcp 9100 9105 "$SG_ID" "rango de nodos Erlang distribuido" || return 1

  echo "===== AMI Ubuntu 24.04 ARM64 ====="
  local AMI_ID ROOT_DEV
  read -r AMI_ID ROOT_DEV < <(aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*" \
              "Name=state,Values=available" \
    --query "sort_by(Images, &CreationDate)[-1].[ImageId,RootDeviceName]" \
    --output text)
  need "AMI"        "$AMI_ID"   || return 1
  need "RootDevice" "$ROOT_DEV" || return 1

  echo "===== user-data (swap + tuning) ====="
  local UD
  UD=$(mktemp)
  cat > "$UD" << EOF
#!/bin/bash
set -e
if [ ! -f /swapfile ]; then
  fallocate -l ${SWAP_GB}G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=\$((${SWAP_GB}*1024))
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi
sysctl -w vm.swappiness=10
echo 'vm.swappiness=10' > /etc/sysctl.d/99-plf-swap.conf
apt-get update -y
EOF
  echo "   user-data en $UD ($(wc -c < "$UD") bytes)"

  echo "===== Lanzar instancia ====="
  local INSTANCE_ID
  INSTANCE_ID=$(aws ec2 run-instances \
    --image-id "$AMI_ID" \
    --count 1 \
    --instance-type "$INSTANCE_TYPE" \
    --key-name "$KEY_NAME" \
    --security-group-ids "$SG_ID" \
    --subnet-id "$SUBNET_ID" \
    --associate-public-ip-address \
    --block-device-mappings "[{\"DeviceName\":\"$ROOT_DEV\",\"Ebs\":{\"VolumeSize\":$ROOT_GB,\"VolumeType\":\"gp3\",\"DeleteOnTermination\":true}}]" \
    --user-data "file://$UD" \
    --tag-specifications \
        "ResourceType=instance,Tags=[$TAGS]" \
        "ResourceType=volume,Tags=[$TAGS]" \
    --query 'Instances[0].InstanceId' \
    --output text)
  need "InstanceId" "$INSTANCE_ID" || return 1
  rm -f "$UD"

  echo "===== Esperando instance-running ====="
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"

  local PUBLIC_IP
  PUBLIC_IP=$(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].PublicIpAddress" \
    --output text)

  echo
  echo "   InstanceId : $INSTANCE_ID"
  echo "   IP pública : $PUBLIC_IP"
  echo "   SSH        : ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"
  echo "   (el swap se crea en el primer arranque, ~1 min: 'free -h' para verificar)"
}

# ----- 3) Listar EC2 existentes -----
listar_instancias() {
  echo
  echo "===== Instancias EC2 (región $AWS_DEFAULT_REGION) ====="
  local out
  out=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query "Reservations[].Instances[].[InstanceId,Tags[?Key=='Name']|[0].Value,InstanceType,State.Name,PublicIpAddress]" \
    --output table)
  local total
  total=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query "length(Reservations[].Instances[])" --output text)
  if [ -z "$out" ] || ! echo "$out" | grep -q '|'; then
    echo "   (sin instancias activas)"
  else
    echo "$out"
  fi
  echo
  echo "   Tienes $total instancia(s) registrada(s)."
  echo "   💰 Cualquier instancia en estado 'running' o 'stopping' sigue consumiendo"
  echo "      créditos del Learner Lab. Usa la opción 4 para terminarla, o"
  echo "      'aws ec2 stop-instances --instance-ids <ID>' si solo quieres pausarla."
}

# ----- 4) Terminar EC2 dado su ID -----
terminar_instancia() {
  echo
  echo "===== Terminar instancia EC2 ====="
  listar_instancias
  echo
  read -r -p "   ID de la instancia a terminar (i-xxxxxxxx, vacío para cancelar): " ID
  [ -z "$ID" ] && { echo "   Cancelado."; return 0; }

  local existe
  existe=$(aws ec2 describe-instances --instance-ids "$ID" \
    --query "Reservations[0].Instances[0].InstanceId" --output text 2>/dev/null) || true
  if [ -z "$existe" ] || [ "$existe" = "None" ]; then
    echo "   ❌ No se encontró la instancia $ID." >&2
    return 1
  fi

  echo "   (si solo quieres pausarla sin perderla, usa 'aws ec2 stop-instances --instance-ids $ID' en vez de esto)"
  read -r -p "   ⚠️  Esto TERMINA (borra) $ID permanentemente. Escribe 'si' para confirmar: " ok
  [ "$ok" = "si" ] || { echo "   Abortado por el usuario."; return 0; }

  aws ec2 terminate-instances --instance-ids "$ID" \
    --query "TerminatingInstances[0].[InstanceId,CurrentState.Name]" --output text
  echo "   🗑️  Terminación solicitada para $ID."
}

# ----- Menú -----
mostrar_banner() {
  clear
  cat << "EOF"
  ░██████  ░██                              ░██   ░██████   ░██                   ░██ ░██
 ░██   ░██ ░██                              ░██  ░██   ░██  ░██                   ░██ ░██
░██        ░██  ░███████  ░██    ░██  ░████████ ░██         ░████████   ░███████  ░██ ░██
░██        ░██ ░██    ░██ ░██    ░██ ░██    ░██  ░████████  ░██    ░██ ░██    ░██ ░██ ░██
░██        ░██ ░██    ░██ ░██    ░██ ░██    ░██         ░██ ░██    ░██ ░█████████ ░██ ░██
 ░██   ░██ ░██ ░██    ░██ ░██   ░███ ░██   ░███  ░██   ░██  ░██    ░██ ░██        ░██ ░██
  ░██████  ░██  ░███████   ░█████░██  ░█████░██   ░██████   ░██    ░██  ░███████  ░██ ░██
EOF
  echo "🧩 CloudShell AWS - Gestión de nodos EC2 ARM64"
}

command -v aws >/dev/null || { echo "❌ El AWS CLI no está disponible en esta shell." >&2; exit 1; }

while true; do
  mostrar_banner
  echo
  echo "  1) Crear EC2 — ARM Assembly (Lenguajes de Interfaz)"
  echo "  2) Crear EC2 — Programación Lógica y Funcional"
  echo "  3) Listar EC2 existentes (ID, tipo, estado, IP)"
  echo "  4) Terminar EC2 (por ID)"
  echo "  5) Salir"
  echo
  read -r -p "Opción: " opcion

  case "$opcion" in
    1) crear_arm_assembly ;;
    2) crear_prog_funcional ;;
    3) listar_instancias ;;
    4) terminar_instancia ;;
    5) echo "Adiós 👋"; exit 0 ;;
    *) echo "Opción inválida." ;;
  esac

  echo
  read -r -p "Presiona ENTER para volver al menú..." _
done
