# Output value definitions

output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."
  value = aws_s3_bucket.lambda_bucket.id
}

output "function_name" {
  description = "Name of function"
  value = aws_lambda_function.this.function_name
}

output "function_alias_name" {
  description = "Name of the function alias"
  value = aws_lambda_alias.this.name
}
