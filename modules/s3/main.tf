#s3 main.tf

resource "aws_s3_bucket" "cf_project_bucket" {
  bucket = "${var.bucket_name}"
  tags = {
    Name = var.tags
  }
}

# resources = [
#   aws_s3_bucket.cf_project_bucket.arn,
#   "${aws_s3_bucket.cf_project_bucket.arn}/*",
#   ]

# An ACL will enable you to manage access to bucket and objects
resource "aws_s3_bucket_acl" "cf_bucket_acl" {
  bucket = aws_s3_bucket.cf_project_bucket.id
  acl    = var.acl
}

# This will block all public access
resource "aws_s3_bucket_public_access_block" "cf_project" {
  bucket = aws_s3_bucket.cf_project_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Image and Log objects
resource "aws_s3_object" "cf-project-images" {
  bucket = var.bucket_name
  key    = "images/"
  source = "/dev/null"
  
  depends_on = [aws_s3_bucket.cf_project_bucket]
}

resource "aws_s3_object" "cf-project-logs" {
  bucket = var.bucket_name
  key    = "logs/"
  source = "/dev/null"
  
  depends_on = [aws_s3_bucket.cf_project_bucket]
}

resource "aws_s3_bucket_lifecycle_configuration" "cf-project" {
  bucket = aws_s3_bucket.cf_project_bucket.id

  # This rule will move objects older than 90 days to GLACIER
  rule {
    id = "Rule 1 Images"
    filter {
      prefix = "Images/"
    }
    transition {
      days          = 90
      storage_class = "GLACIER"
    }
    status = "Enabled"
  }

  # This rule will delete objects older than 90 days
  rule {
    id = "Rule 2 Logs"
    filter {
      prefix = "Logs/"
    }
    expiration {
      days = 90
    }
    status = "Enabled"
  }
}