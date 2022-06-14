output "bucket" {
    value = aws_s3_bucket.bucket123456abc
  
}

output "instance_profile" {
    value = aws_s3_instance_profile.instance_profile
}

output "test_policy" {
    value = aws_iam_policy.test_policy
}

output "test_role" {
    value = aws_iam_role.test_role
}

output "test-attach" {
    value = aws_iam_role_policy_attachment.test-attach
}

