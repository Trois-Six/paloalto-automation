output "bootstrap_bucket_id" {
  value = aws_s3_bucket.this.id
}

output "bootstrap_bucket_name" {
  value = aws_s3_bucket.this.bucket
}
