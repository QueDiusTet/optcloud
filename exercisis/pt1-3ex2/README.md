# Exercici 2 — Crear una VPC amb 3 subnets i 6 instàncies EC2

## Objectiu
Crear una VPC (`10.0.0.0/16`) amb 3 subxarxes i 2 instàncies EC2 a cada subnet, totes a `us-east-1a`.

---

## 🖥️ Part 1 — Fer-ho manualment a AWS

1. AWS Console → **VPC → Create VPC**
   - CIDR: `10.0.0.0/16`
2. Crea 3 subnets dins la VPC:
   - SubnetA: `10.0.32.0/25`
   - SubnetB: `10.0.30.0/23`
   - SubnetC: `10.0.33.0/28`
3. Crea un Security Group amb port 22 obert per SSH.
4. Crea 2 instàncies per cada subnet.
5. Desa captures a `assets/Imatges/console-ex2-*.png`.

---

## ⚙️ Part 2 — Fer-ho amb Terraform

1. Copia l’AMI ID a `variables.tf`.
2. Executa:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```
3. Comprova que tens 3 subxarxes i 6 instàncies.
4. Desa captura a `assets/Imatges/terraform-ex2.png`.
