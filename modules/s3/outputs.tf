#s3 outputs.tf

output "bucket_name" {
  value = aws_s3_bucket.cf_project_bucket.bucket
}
