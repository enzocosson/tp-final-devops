# Variables d'entrée
variable "aws_region" {
  description = "Région AWS où déployer l'infrastructure"
  type        = string
  default     = "eu-west-1"
}

variable "bucket_name" {
  description = "Nom de base du bucket S3 (un suffixe aléatoire sera ajouté)"
  type        = string
  default     = "react-app-tp2-bis"
}

variable "environment" {
  description = "Environnement de déploiement"
  type        = string
  default     = "production"
}

variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "tp2-bis-react-app"
}

variable "domain_name" {
  description = "Nom de domaine pour CloudFront (optionnel)"
  type        = string
  default     = ""
}
