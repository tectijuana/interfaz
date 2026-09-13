#!/bin/bash
# ==========================================
# Script: ec2-interfaz.sh
# Autor: MC. René Solis R. @IoTeacher
# Descripción: Menú para el estudiante — crear/listar/terminar instancias EC2
#              ARM64 usadas en los cursos de Lenguajes de Interfaz y de
#              Programación Lógica y Funcional. Una sola función parametrizada
#              lanza ambos perfiles; solo cambian tipo/AMI/puertos/tamaño.
# ==========================================

set -euo pipefail

export AWS_DEFAULT_REGION="${AWS_DEFAULT_REGION:-us-east-1}"

# ----- colores (se desactivan solos si no hay TTY o si NO_COLOR está definido) -----
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
  C_RESET=$'\033[0m'; C_BOLD=$'\033[1m'; C_DIM=$'\033[2m'
  C_CYAN=$'\033[36m'; C_GREEN=$'\033[32m'; C_YELLOW=$'\033[33m'
  C_RED=$'\033[31m'; C_BLUE=$'\033[34m'
else
  C_RESET=""; C_BOLD=""; C_DIM=""; C_CYAN=""; C_GREEN=""; C_YELLOW=""; C_RED=""; C_BLUE=""
fi

log_ok()   { echo "${C_GREEN}✅ $*${C_RESET}"; }
log_err()  { echo "${C_RED}❌ $*${C_RESET}" >&2; }
log_warn() { echo "${C_YELLOW}⚠️  $*${C_RESET}"; }
log_step() { echo; echo "${C_BOLD}${C_BLUE}== $* ==${C_RESET}"; }

# Identidad AWS: se resuelve una sola vez al arrancar (no en cada refresco de menú)
# para no meter latencia/llamadas de más solo por navegar el menú.
AWS_WHOAMI="$(aws sts get-caller-identity --query 'Arn' --output text 2>/dev/null || echo "no disponible — revisa tus credenciales AWS")"

banner() {
  clear
  echo "${C_CYAN}"
  cat << "EOF"
  ░██████  ░██                              ░██   ░██████   ░██                   ░██ ░██
 ░██   ░██ ░██                              ░██  ░██   ░██  ░██                   ░██ ░██
░██        ░██  ░███████  ░██    ░██  ░████████ ░██         ░████████   ░███████  ░██ ░██
░██        ░██ ░██    ░██ ░██    ░██ ░██    ░██  ░████████  ░██    ░██ ░██    ░██ ░██ ░██
░██        ░██ ░██    ░██ ░██    ░██ ░██    ░██         ░██ ░██    ░██ ░█████████ ░██ ░██
 ░██   ░██ ░██ ░██    ░██ ░██   ░███ ░██   ░███  ░██   ░██  ░██    ░██ ░██        ░██ ░██
  ░██████  ░██  ░███████   ░█████░██  ░█████░██   ░██████   ░██    ░██  ░███████  ░██ ░██
EOF
  echo "${C_RESET}"
  echo "🧩 ${C_BOLD}CloudShell AWS - Nodos ARM64${C_RESET}"
  echo "${C_DIM}   Región: ${AWS_DEFAULT_REGION}  ·  Identidad: ${AWS_WHOAMI}${C_RESET}"
}

# abortar si un valor salió vacío o "None" (típico de --query --output text sin match)
need() {
  local nombre="$1" valor="$2"
  if [ -z "$valor" ] || [ "$valor" = "None" ]; then
    echo "❌ No se pudo resolver: $nombre (valor='$valor')" >&2
    exit 1
  fi
  echo "   $nombre = $valor"
}

# autorizar una regla de ingress solo si no existe ya (idempotente)
autorizar_ingress() {
  local sg="$1" proto="$2" desde="$3" hasta="$4" origen="$5" desc="$6"
  local origen_flag puerto out
  if [[ "$origen" == sg-* ]]; then
    origen_flag=(--source-group "$origen")
  else
    origen_flag=(--cidr "$origen")
  fi
  puerto="$( [ "$desde" = "$hasta" ] && echo "$desde" || echo "$desde-$hasta" )"

  if out=$(aws ec2 authorize-security-group-ingress \
            --group-id "$sg" --protocol "$proto" --port "$puerto" \
            "${origen_flag[@]}" 2>&1); then
    echo "   ➕ agregada   $proto $puerto  <- $origen   ($desc)"
  elif echo "$out" | grep -q "InvalidPermission.Duplicate"; then
    echo "   ✅ ya existe  $proto $puerto  <- $origen"
  else
    echo "   ❌ error autorizando $proto $puerto <- $origen" >&2
    echo "$out" >&2
    return 1
  fi
}

# ----------------------------------------------------------------------
# crear_ec2 <perfil>
# perfil: "interfaz" (Leng. de Interfaz) | "plf" (Programación Lógica y Funcional)
# Toda la diferencia entre cursos vive aquí como config; el flujo es uno solo.
# ----------------------------------------------------------------------
crear_ec2() {
  local perfil="$1"

  KEY_NAME="${KEY_NAME:-llavesita}"
  SG_NAME="${SG_NAME:-arm64-ssh-group}"
  local extra_ports=() root_gb="" swap_gb="" chequear_duplicado=false

  case "$perfil" in
    interfaz)
      DESC="Leng. Ensamblador para ARM64"
      INSTANCE_TYPE="${INSTANCE_TYPE:-t4g.micro}"
      INSTANCE_NAME="${INSTANCE_NAME:-Curso Leng. de Interfaz}"
      AMI_PATTERN="ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*"
      ;;
    plf)
      DESC="Programacion Logica y Funcional - ARM64"
      INSTANCE_TYPE="${INSTANCE_TYPE:-t4g.large}"
      INSTANCE_NAME="${INSTANCE_NAME:-Curso-PLF}"
      AMI_PATTERN="ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-arm64-server-*"
      root_gb="${ROOT_GB:-30}"
      swap_gb="${SWAP_GB:-2}"
      # Erlang distribuido (unidad 4 / proyecto final). Origen = el propio SG,
      # nunca 0.0.0.0/0: un nodo con la cookie conocida permite ejecutar código remoto.
      extra_ports=("tcp 4369 4369 EPMD (Erlang Port Mapper Daemon)" \
                   "tcp 9100 9105 rango de nodos Erlang distribuido")
      chequear_duplicado=true
      ;;
    *)
      echo "❌ Perfil desconocido: $perfil" >&2
      return 1
      ;;
  esac

  echo "===== CONFIG ($perfil) ====="
  echo "   INSTANCE_TYPE = $INSTANCE_TYPE"
  echo "   INSTANCE_NAME = $INSTANCE_NAME"
  [ -n "$root_gb" ] && echo "   ROOT_GB / SWAP_GB = ${root_gb} / ${swap_gb}"

  if [ "$chequear_duplicado" = true ]; then
    echo
    echo "===== Guarda contra duplicados ====="
    local ya
    ya=$(aws ec2 describe-instances \
      --filters "Name=tag:Name,Values=$INSTANCE_NAME" \
                "Name=instance-state-name,Values=pending,running,stopping,stopped" \
      --query "Reservations[].Instances[].[InstanceId,State.Name,PublicIpAddress]" \
      --output text)
    if [ -n "$ya" ]; then
      echo "⚠️  Ya existe una instancia con Name=$INSTANCE_NAME:"
      echo "$ya" | sed 's/^/     /'
      read -r -p "   ¿Lanzar OTRA de todas formas? (escribe 'si' para continuar) " ok
      [ "$ok" = "si" ] || { echo "   Abortado por el usuario."; return 0; }
    else
      echo "   OK, no hay instancias previas con ese nombre."
    fi
  fi

  echo
  echo "===== 1. Key Pair ====="
  if aws ec2 describe-key-pairs --key-names "$KEY_NAME" > /dev/null 2>&1; then
    if [ -f "${KEY_NAME}.pem" ]; then
      echo "   ✅ Key '$KEY_NAME' y archivo .pem ya existen"
    else
      echo "   ⚠️  Key '$KEY_NAME' existe en AWS pero falta ${KEY_NAME}.pem local → recreando..."
      aws ec2 delete-key-pair --key-name "$KEY_NAME"
      aws ec2 create-key-pair --key-name "$KEY_NAME" \
        --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
      chmod 400 "${KEY_NAME}.pem"
    fi
  else
    echo "   🆕 Creando nueva key '$KEY_NAME'..."
    aws ec2 create-key-pair --key-name "$KEY_NAME" \
      --query 'KeyMaterial' --output text > "${KEY_NAME}.pem"
    chmod 400 "${KEY_NAME}.pem"
  fi

  echo
  echo "===== 2. VPC + Subnet default ====="
  VPC_ID=$(aws ec2 describe-vpcs --filters "Name=isDefault,Values=true" \
    --query "Vpcs[0].VpcId" --output text)
  need "VPC default" "$VPC_ID"
  SUBNET_ID=$(aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$VPC_ID" "Name=default-for-az,Values=true" \
    --query "Subnets[0].SubnetId" --output text)
  need "Subnet default" "$SUBNET_ID"

  echo
  echo "===== 3. Security Group ====="
  SG_ID=$(aws ec2 describe-security-groups \
    --filters "Name=group-name,Values=$SG_NAME" "Name=vpc-id,Values=$VPC_ID" \
    --query 'SecurityGroups[0].GroupId' --output text)
  if [ "$SG_ID" = "None" ] || [ -z "$SG_ID" ]; then
    SG_ID=$(aws ec2 create-security-group \
      --group-name "$SG_NAME" --description "$DESC" --vpc-id "$VPC_ID" \
      --query 'GroupId' --output text)
    echo "   🆕 Security group creado."
  fi
  need "Security group" "$SG_ID"

  echo
  echo "===== 4. Reglas de entrada (idempotentes) ====="
  autorizar_ingress "$SG_ID" tcp 22 22 "0.0.0.0/0" "SSH"
  local regla
  for regla in "${extra_ports[@]:-}"; do
    [ -z "$regla" ] && continue
    # shellcheck disable=SC2086
    set -- $regla
    autorizar_ingress "$SG_ID" "$1" "$2" "$3" "$SG_ID" "${*:4}"
  done

  echo
  echo "===== 5. AMI Ubuntu ARM64 ====="
  read -r AMI_ID ROOT_DEV < <(aws ec2 describe-images \
    --owners 099720109477 \
    --filters "Name=name,Values=$AMI_PATTERN" "Name=state,Values=available" \
    --query "sort_by(Images, &CreationDate)[-1].[ImageId,RootDeviceName]" \
    --output text)
  need "AMI"        "$AMI_ID"
  need "RootDevice" "$ROOT_DEV"

  local run_args=(
    --image-id "$AMI_ID"
    --count 1
    --instance-type "$INSTANCE_TYPE"
    --key-name "$KEY_NAME"
    --security-group-ids "$SG_ID"
    --subnet-id "$SUBNET_ID"
    --associate-public-ip-address
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCE_NAME'}]"
    --query 'Instances[0].InstanceId'
    --output text
  )

  local ud=""
  if [ -n "$root_gb" ]; then
    run_args+=(--block-device-mappings "[{\"DeviceName\":\"$ROOT_DEV\",\"Ebs\":{\"VolumeSize\":$root_gb,\"VolumeType\":\"gp3\",\"DeleteOnTermination\":true}}]")
  fi
  if [ -n "$swap_gb" ]; then
    echo
    echo "===== 6. user-data (swap ${swap_gb}GiB) ====="
    ud=$(mktemp)
    cat > "$ud" << EOF
#!/bin/bash
set -e
if [ ! -f /swapfile ]; then
  fallocate -l ${swap_gb}G /swapfile || dd if=/dev/zero of=/swapfile bs=1M count=\$((${swap_gb}*1024))
  chmod 600 /swapfile
  mkswap /swapfile
  swapon /swapfile
  echo '/swapfile none swap sw 0 0' >> /etc/fstab
fi
sysctl -w vm.swappiness=10
echo 'vm.swappiness=10' > /etc/sysctl.d/99-swap.conf
apt-get update -y
EOF
    run_args+=(--user-data "file://$ud")
  fi

  echo
  echo "===== 7. Lanzar instancia ====="
  INSTANCE_ID=$(aws ec2 run-instances "${run_args[@]}")
  need "InstanceId" "$INSTANCE_ID"
  [ -n "$ud" ] && rm -f "$ud"

  echo
  echo "===== 8. Esperando a instance-running ====="
  aws ec2 wait instance-running --instance-ids "$INSTANCE_ID"
  echo "   running ✔"

  echo
  echo "===== 9. Datos finales ====="
  read -r PUBLIC_IP AZ STATE < <(aws ec2 describe-instances \
    --instance-ids "$INSTANCE_ID" \
    --query "Reservations[0].Instances[0].[PublicIpAddress,Placement.AvailabilityZone,State.Name]" \
    --output text)
  need "IP pública" "$PUBLIC_IP"

  echo
  echo "======================================================================"
  echo " NODO LISTO ($perfil)"
  echo "----------------------------------------------------------------------"
  echo "   InstanceId : $INSTANCE_ID   ($STATE, $AZ)"
  echo "   Tipo       : $INSTANCE_TYPE"
  echo "   IP pública : $PUBLIC_IP"
  echo "   SSH: ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"
  echo "----------------------------------------------------------------------"
  echo "   Gestión (por tag Name=$INSTANCE_NAME):"
  echo "     Apagar  : aws ec2 stop-instances      --instance-ids $INSTANCE_ID"
  echo "     Encender: aws ec2 start-instances     --instance-ids $INSTANCE_ID"
  echo "     Borrar  : aws ec2 terminate-instances --instance-ids $INSTANCE_ID"
  echo "======================================================================"
}

listar_instancias() {
  echo "===== Instancias EC2 (no terminadas) ====="
  aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query "Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key=='Name']|[0].Value,PublicIpAddress,InstanceType]" \
    --output table
}

terminar_instancia() {
  echo "===== Instancias disponibles para terminar ====="
  local filas
  filas=$(aws ec2 describe-instances \
    --filters "Name=instance-state-name,Values=pending,running,stopping,stopped" \
    --query "Reservations[].Instances[].[InstanceId,State.Name,Tags[?Key=='Name']|[0].Value,PublicIpAddress]" \
    --output text)

  if [ -z "$filas" ]; then
    echo "No hay instancias activas."
    return 0
  fi

  echo "$filas" | nl -w2 -s') '

  local idx total id
  total=$(echo "$filas" | wc -l | tr -d ' ')
  read -r -p "Número de la instancia a terminar (0 para cancelar): " idx

  if [ "$idx" = "0" ] || [ -z "$idx" ]; then
    echo "Cancelado."
    return 0
  fi

  if ! [[ "$idx" =~ ^[0-9]+$ ]] || [ "$idx" -lt 1 ] || [ "$idx" -gt "$total" ]; then
    echo "❌ Opción inválida." >&2
    return 1
  fi

  id=$(echo "$filas" | sed -n "${idx}p" | awk '{print $1}')

  read -r -p "⚠️ ¿Confirmas terminar $id? (escribe 'si' para continuar) " ok
  if [ "$ok" != "si" ]; then
    echo "Cancelado."
    return 0
  fi

  aws ec2 terminate-instances --instance-ids "$id" --output table
}

pausar() {
  echo
  read -r -p "${C_DIM}Presiona Enter para continuar...${C_RESET}" _
}

# Ctrl+C en medio de una operación AWS no debe dejar al alumno con un error crudo.
trap 'echo; log_warn "Interrumpido por el usuario."; exit 130' INT

while true; do
  banner
  echo
  echo "${C_BOLD}===== MENÚ =====${C_RESET}"
  echo "  ${C_CYAN}1)${C_RESET} Crear EC2-VM para Leng. de Interfaz"
  echo "  ${C_CYAN}2)${C_RESET} Crear EC2-VM para Programación Lógica y Funcional"
  echo "  ${C_CYAN}3)${C_RESET} Listar todas las EC2-VM"
  echo "  ${C_CYAN}4)${C_RESET} Terminar alguna EC2-VM"
  echo "  ${C_CYAN}5)${C_RESET} Salir"
  echo
  read -r -p "${C_BOLD}Elige una opción [1-5]: ${C_RESET}" opcion

  case "$opcion" in
    1) crear_ec2 interfaz; pausar ;;
    2) crear_ec2 plf; pausar ;;
    3) listar_instancias; pausar ;;
    4) terminar_instancia; pausar ;;
    5) echo "👋 Hasta luego."; exit 0 ;;
    *) log_err "Opción inválida: '$opcion' (usa un número del 1 al 5)"; pausar ;;
  esac
done
