# Sorties importantes
output "s3_bucket_name" {
  description = "Nom du bucket S3"
  value       = aws_s3_bucket.react_app.bucket
}

output "s3_bucket_website_endpoint" {
  description = "URL du site web S3"
  value       = aws_s3_bucket_website_configuration.react_app.website_endpoint
}

output "cloudfront_distribution_id" {
  description = "ID de la distribution CloudFront"
  value       = aws_cloudfront_distribution.react_app.id
}

output "cloudfront_domain_name" {
  description = "Nom de domaine CloudFront"
  value       = aws_cloudfront_distribution.react_app.domain_name
}

output "cloudfront_url" {
  description = "URL complète de l'application"
  value       = "https://${aws_cloudfront_distribution.react_app.domain_name}"
}

output "s3_bucket_arn" {
  description = "ARN du bucket S3"
  value       = aws_s3_bucket.react_app.arn
}

# Outputs pour DynamoDB
output "dynamodb_table_name" {
  description = "Nom de la table DynamoDB pour les todos"
  value       = aws_dynamodb_table.todos.name
}

output "dynamodb_table_arn" {
  description = "ARN de la table DynamoDB pour les todos"
  value       = aws_dynamodb_table.todos.arn
}

output "dynamodb_role_arn" {
  description = "ARN du rôle IAM pour l'accès à DynamoDB"
  value       = aws_iam_role.dynamodb_role.arn
}

# Outputs pour ECR
output "ecr_backend_repository_url" {
  description = "URL du repository ECR pour le backend"
  value       = aws_ecr_repository.backend.repository_url
}

output "ecr_frontend_repository_url" {
  description = "URL du repository ECR pour le frontend"
  value       = aws_ecr_repository.frontend.repository_url
}

output "ecr_backend_repository_name" {
  description = "Nom du repository ECR pour le backend"
  value       = aws_ecr_repository.backend.name
}

output "ecr_frontend_repository_name" {
  description = "Nom du repository ECR pour le frontend"
  value       = aws_ecr_repository.frontend.name
}

# Outputs pour l'Application Load Balancer
output "alb_dns_name" {
  description = "Nom DNS de l'Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID de l'Application Load Balancer"
  value       = aws_lb.main.zone_id
}

output "backend_api_url" {
  description = "URL de l'API backend"
  value       = "http://${aws_lb.main.dns_name}"
}

# Outputs pour ECS
output "ecs_cluster_name" {
  description = "Nom du cluster ECS"
  value       = aws_ecs_cluster.main.name
}

output "ecs_service_name" {
  description = "Nom du service ECS backend"
  value       = aws_ecs_service.backend.name
}

# Outputs pour VPC
output "vpc_id" {
  description = "ID du VPC"
  value       = aws_vpc.main.id
}

output "private_subnet_ids" {
  description = "IDs des subnets privés"
  value       = aws_subnet.private[*].id
}

output "public_subnet_ids" {
  description = "IDs des subnets publics"
  value       = aws_subnet.public[*].id
}
