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
