# Infrastructure definitions

provider "aws" {
  version = "~> 2.0"
  region  = var.aws_region
}

locals {
  default_lambda_timeout = 10
  default_lambda_log_retention = 1
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = "lambda-bucket-assets"
  acl    = "private"
}

resource "aws_s3_bucket_object" "lambda_default" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "main-${uuid()}.zip"
  source = "../functions/ingestion/main.zip"
  etag   = filemd5("../functions/ingestion/main.zip")
}

resource "aws_lambda_function" "this" {
  s3_bucket            = aws_s3_bucket.lambda_bucket.id
  s3_key               = aws_s3_bucket_object.lambda_default.key
  timeout              = local.default_lambda_timeout
  function_name        = "Ingestion-function"
  runtime              = "nodejs12.x"
  handler              = "dist/index.handler"
  publish              = true
  source_code_hash     = "${filebase64sha256("../functions/ingestion/main.zip")}"
  role                 = aws_iam_role.lambda_exec.arn
  environment {
    variables = {
      DefaultRegion = var.aws_region
    }
  }
}

resource "aws_lambda_alias" "this" {
  name             = "ingestion-dev"
  description      = "alias for the ingestion function"
  function_name    = aws_lambda_function.this.arn
  function_version = aws_lambda_function.this.version
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/aws/lambda/${aws_lambda_function.this.function_name}"
  retention_in_days = local.default_lambda_log_retention
}

resource "aws_iam_role" "lambda_exec" {
  name               = "ingestion-function-exec-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Sid       = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

data "aws_iam_policy_document" "runtime_policy_doc" {
  version = "2012-10-17"
  statement {
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
    effect = "Allow"
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_policy" "lambda_runtime_policy" {
  name = "ingestion-function-runtime-policy"
  policy = data.aws_iam_policy_document.runtime_policy_doc.json
}

resource "aws_iam_policy_attachment" "attach_policy_to_role_lambda" {
  name       = "ingestion-function-lambda-role-attachment"
  roles      = [aws_iam_role.lambda_exec.name]
  policy_arn = aws_iam_policy.lambda_runtime_policy.arn
}
