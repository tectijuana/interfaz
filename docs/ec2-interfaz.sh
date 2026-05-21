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
