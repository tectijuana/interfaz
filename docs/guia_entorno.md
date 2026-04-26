
<img width="1402" height="1122" alt="image" src="https://gist.github.com/user-attachments/assets/26ca73f9-f580-4f33-8295-7768295fc806" />

---

## 🧩 Definición técnica

CloudShell es un **shell Linux administrado por AWS** (basado en Amazon Linux) que incluye:

* **AWS CLI preconfigurado** con tus credenciales activas
* Herramientas comunes: `bash`, `git`, `python`, `node`, `zip`, `jq`
* Acceso directo a servicios como EC2, S3, IAM, etc.

👉 Todo corre en la nube, no en tu máquina local.

---

## ⚙️ Características clave

* ✔️ **Listo para usar** (no requiere instalación)
* ✔️ **Autenticación automática** (usa la sesión de AWS activa)
* ✔️ **Persistencia limitada (~1 GB)** para archivos
* ✔️ Acceso desde navegador (ideal para labs y docencia)

---

## 🧪 Uso típico

* Administración de infraestructura (EC2, S3, redes)
* Ejecución de scripts (`.sh`, Python con `boto3`)
* Automatización de tareas en AWS
* Prácticas en entornos educativos como **AWS Academy**

---

## ⚠️ Limitaciones importantes

* ❌ Almacenamiento **no permanente** (especialmente en labs)
* ❌ Recursos dependen del estado del entorno (lab activo/inactivo)
* ❌ Restricciones de permisos según la cuenta o curso

---

## 🧠 En pocas palabras

CloudShell es como tener un **terminal Linux listo y conectado a AWS**, accesible desde el navegador, ideal para **administración, automatización y aprendizaje sin configuración previa**.

----



# ✔️ 1. Listar máquinas virtuales (EC2)

```bash
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name,IP:PublicIpAddress}' \
  --output table
```

👉 Te mostrará algo como:

```
-----------------------------------------------------------------------------------
|                                DescribeInstances                                |
+----------------------+----------------+---------------------------+-------------+
|          ID          |      IP        |           Name            |    State    |
+----------------------+----------------+---------------------------+-------------+
|  i-0f93b85a7b3f66276 |  None          |  InterfazSrv              |  running    |
|  i-0654b95ec5f094a9c |  None          |  None                     |  running    |
|  i-0a59f914affbccac8 |  3.235.63.43   |  Curso Leng. de Interfaz  |  running    |
|  i-0bd474e8b0d262fe7 |  44.201.69.17  |  Curso Leng. de Interfaz  |  running    |
|  i-0fd3c86d6950b6094 |  35.175.212.74 |  Curso Leng. de Interfaz  |  running    |
|  i-060c3004fd5b84759 |  None          |  CodeSpace-Interfaz       |  running    |
+----------------------+----------------+---------------------------+-------------+
```

---

# ✔️ 2. Elegir cuál borrar

Tomas el **InstanceId**, por ejemplo:

```bash
i-060c3004fd5b84759
```

---

# ✔️ 3. Eliminar (terminar) la instancia

```bash
aws ec2 terminate-instances --instance-ids i-060c3004fd5b84759
```

---

# ✔️ 4. Esperar a que se elimine (opcional pero recomendado)

```bash
aws ec2 wait instance-terminated --instance-ids i-060c3004fd5b84759
```

---

# 🔴 Borrado múltiple (si quieres limpiar todo)

```bash
aws ec2 describe-instances \
  --query 'Reservations[].Instances[].InstanceId' \
  --output text | xargs aws ec2 terminate-instances --instance-ids
```

## Salida esperada

```plaintext

ee_W_5721431@runweb224137:~$ aws ec2 describe-instances \
>   --query 'Reservations[].Instances[].{ID:InstanceId,Name:Tags[?Key==`Name`]|[0].Value,State:State.Name,IP:PublicIpAddress}' \
>   --output table
-----------------------------------------------------------------------------------
|                                DescribeInstances                                |
+----------------------+----------------+---------------------------+-------------+
|          ID          |      IP        |           Name            |    State    |
+----------------------+----------------+---------------------------+-------------+
|  i-0f93b85a7b3f66276 |  None          |  InterfazSrv              |  running    |
|  i-0654b95ec5f094a9c |  None          |  None                     |  running    |
|  i-0a59f914affbccac8 |  3.235.63.43   |  Curso Leng. de Interfaz  |  running    |
|  i-0bd474e8b0d262fe7 |  44.201.69.17  |  Curso Leng. de Interfaz  |  running    |
|  i-0fd3c86d6950b6094 |  35.175.212.74 |  Curso Leng. de Interfaz  |  running    |
|  i-060c3004fd5b84759 |  None          |  CodeSpace-Interfaz       |  terminated |
+----------------------+----------------+---------------------------+-------------+
eee_W_5721431@runweb224137:~$ aws ec2 describe-instances \
>   --query 'Reservations[].Instances[].InstanceId' \
>   --output text | xargs aws ec2 terminate-instances --instance-ids
{
    "TerminatingInstances": [
        {
            "CurrentState": {
                "Code": 48,
                "Name": "terminated"
            },
            "InstanceId": "i-0f93b85a7b3f66276",
            "PreviousState": {
                "Code": 48,
                "Name": "terminated"
            }
        },
        {
            "CurrentState": {
                "Code": 48,
                "Name": "terminated"
            },
            "InstanceId": "i-060c3004fd5b84759",
            "PreviousState": {
                "Code": 48,
                "Name": "terminated"
            }
        },
        {
            "CurrentState": {
                "Code": 32,
                "Name": "shutting-down"
            },
            "InstanceId": "i-0bd474e8b0d262fe7",
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        },
        {
            "CurrentState": {
                "Code": 32,
                "Name": "shutting-down"
            },
            "InstanceId": "i-0a59f914affbccac8",
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        },
        {
            "CurrentState": {
                "Code": 32,
                "Name": "shutting-down"
            },
            "InstanceId": "i-0fd3c86d6950b6094",
            "PreviousState": {
                "Code": 16,
                "Name": "running"
            }
        },
        {
            "CurrentState": {
                "Code": 48,
                "Name": "terminated"
            },
            "InstanceId": "i-0654b95ec5f094a9c",
            "PreviousState": {
                "Code": 48,
                "Name": "terminated"
            }
        }
    ]
}
eee_W_5721431@runweb224137:~$ 
eee_W_5721431@runweb224137:~$ 

```



---

# ⚠️ Consideraciones en **AWS Academy**

* Terminar = eliminar completamente (no hay papelera)
* No se puede recuperar la instancia
* El almacenamiento (EBS) normalmente también se elimina

---

# 🧠 Tip útil (docencia)

Si usas nombres en tus scripts:

```bash
--tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='Alumno1'}]"
```

Luego puedes filtrar:

```bash
aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=Alumno1"
```

---
# CLOUD Shell dentro de AWS Academy Console
---

```bash

#!/bin/bash
# ==========================================
# Script: ec2-interfaz.sh
# Autor: MC. René Solis R. @IoTeacher
# Descripción: Automatizar procedimiento recurrente de nodo ARM64 para curso
#              puede usarse como templete universal
# ==========================================

#!/bin/bash

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

echo "🧩 CloudShell AWS - Nodo ARM64"

echo "===== CONFIG ====="
export AWS_DEFAULT_REGION=us-east-1
KEY_NAME="llavesita"
SG_NAME="arm64-ssh-group"
DESC="Leng. Ensamblador para ARM64"
INSTANCE_TYPE="t4g.micro"
INSTANCE_NAME="Curso Leng. de Interfaz"

echo "===== 1. Key Pair ====="

# Verificar si existe la key en AWS
aws ec2 describe-key-pairs --key-names $KEY_NAME > /dev/null 2>&1

if [ $? -eq 0 ]; then
  echo "⚠️ Key existe en AWS"

  # Verificar si existe el archivo local
  if [ ! -f "${KEY_NAME}.pem" ]; then
    echo "❌ No existe ${KEY_NAME}.pem local → recreando key..."

    aws ec2 delete-key-pair --key-name $KEY_NAME

    aws ec2 create-key-pair \
      --key-name $KEY_NAME \
      --query 'KeyMaterial' \
      --output text > ${KEY_NAME}.pem

    chmod 400 ${KEY_NAME}.pem
  else
    echo "✅ Key y archivo .pem ya existen"
  fi

else
  echo "🆕 Creando nueva key..."

  aws ec2 create-key-pair \
    --key-name $KEY_NAME \
    --query 'KeyMaterial' \
    --output text > ${KEY_NAME}.pem

  chmod 400 ${KEY_NAME}.pem
fi

echo "===== 2. VPC default ====="
VPC_ID=$(aws ec2 describe-vpcs \
  --filters "Name=isDefault,Values=true" \
  --query "Vpcs[0].VpcId" \
  --output text)

echo "===== 3. Security Group ====="
SG_ID=$(aws ec2 describe-security-groups \
  --filters Name=group-name,Values=$SG_NAME \
  --query 'SecurityGroups[0].GroupId' \
  --output text)

if [ "$SG_ID" == "None" ]; then
  SG_ID=$(aws ec2 create-security-group \
    --group-name $SG_NAME \
    --description "$DESC" \
    --vpc-id $VPC_ID \
    --query 'GroupId' \
    --output text)
fi

echo "SG_ID: $SG_ID"

echo "===== 4. Abrir puerto 22 ====="
aws ec2 authorize-security-group-ingress \
  --group-id $SG_ID \
  --protocol tcp \
  --port 22 \
  --cidr 0.0.0.0/0 2>/dev/null

echo "===== 5. Subnet ====="
SUBNET_ID=$(aws ec2 describe-subnets \
  --filters "Name=default-for-az,Values=true" \
  --query "Subnets[0].SubnetId" \
  --output text)

echo "===== 6. AMI Ubuntu ARM64 ====="
AMI_ID=$(aws ec2 describe-images \
  --owners 099720109477 \
  --filters "Name=name,Values=ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-arm64-server-*" \
  --query "Images | sort_by(@, &CreationDate)[-1].ImageId" \
  --output text)

echo "AMI: $AMI_ID"

echo "===== 7. Lanzar instancia ====="
INSTANCE_ID=$(aws ec2 run-instances \
  --image-id $AMI_ID \
  --count 1 \
  --instance-type $INSTANCE_TYPE \
  --key-name $KEY_NAME \
  --security-group-ids $SG_ID \
  --subnet-id $SUBNET_ID \
  --associate-public-ip-address \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value='$INSTANCE_NAME'}]" \
  --query 'Instances[0].InstanceId' \
  --output text)

echo "Instancia: $INSTANCE_ID"

echo "===== 8. Esperando ====="
aws ec2 wait instance-running --instance-ids $INSTANCE_ID

echo "===== 9. IP pública ====="
PUBLIC_IP=$(aws ec2 describe-instances \
  --instance-ids $INSTANCE_ID \
  --query "Reservations[0].Instances[0].PublicIpAddress" \
  --output text)

echo "IP: $PUBLIC_IP"

echo "===== SSH ====="
echo "ssh -i ${KEY_NAME}.pem ubuntu@$PUBLIC_IP"

```
