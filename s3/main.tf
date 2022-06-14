resource "aws_vpc_endpoint" "s3" {
  vpc_id       = var.aws_vpc_endpoint
  service_name = "com.amazonaws.ap-southeast-1.s3"
}

resource "aws_s3_bucket" "bucket123456abc" {
  bucket = "my-tf-test-bucket"

  tags = {
    Name        = "${bucket_name}"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "acl" {
  bucket = aws_s3_bucket.bucket123456abc.id
  acl    = var.acl
}

resource "aws_iam_policy" "test_policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:Describe*",
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

resource "aws_iam_role" "test_role" {
  name = "test_role"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}

resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = aws_iam_role.test_role.name
}

resource "aws_s3_bucket_object" "object_1" {
  bucket = aws_s3_bucket.bucket123456abc.id
  key    = "nginx.txt"
  acl    = "private"  
  source = "./nginx.txt"
  etag = filemd5("./nginx.txt")
}

resource "aws_s3_bucket_object" "object_12" {
  bucket = aws_s3_bucket.bucket123456abc.id
  key    = "ssl-params.txt"
  acl    = "private"  
  source = "./nginx.txt"
  etag = filemd5("./ssl-params.txt")
}

resource "aws_s3_bucket_object" "object_123" {
  bucket = aws_s3_bucket.bucket123456abc.id
  key    = "env.txt"
  acl    = "private"  
  source = "./env.txt"
  etag = filemd5("./env.txt")
}
