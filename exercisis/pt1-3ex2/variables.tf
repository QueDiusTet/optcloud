variable "ami_id" {
  description = "AMI d'Amazon Linux 2023"
  type        = string
  default     = "ami-xxxxxx"
}

variable "key_name" {
  description = "Nom de la clau SSH creada a AWS"
  type        = string
  default     = "terraform-lab-key"
}
