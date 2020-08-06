provider "aws" {
  region = "ap-south-1"
}

# creating a bucket
resource "aws_s3_bucket" "lb1" {
  bucket =var.lambda_bucket
}
# Queriying the role
data "aws_iam_role" "nileshRole" {
  name = var.lambda_role_name
}
# creating a function
resource "aws_lambda_function" "mylb" {
  function_name = var.lambda_name
  handler = "index.handler"
  role = data.aws_iam_role.nileshRole.arn
  runtime = "nodejs10.x"
  filename = var.lambda_filename
  depends_on = [aws_s3_bucket.lb1]
}
data "aws_iam_policy_document" "assume_policy" {

  statement {
    actions = [
      "sts:AssumeRole",
    ]
    principals {
      identifiers = ["lambda.amazonaws.com"]
      type = "Service"
    }
  }
}
resource "aws_lambda_permission" "allow_bucket_triggger" {

  statement_id = "AllowS3ToInvokeMyLambda"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.mylb.function_name
  principal = "s3.amazon.com"
  source_arn = aws_s3_bucket.lb1.arn
}
resource "aws_s3_bucket_notification" "bucket_invoke_lambda" {
  bucket = aws_s3_bucket.lb1.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.mylb.arn
    events = [
      "s3:ObjectCreated:*"
    ]
  }

  depends_on = [aws_lambda_permission.allow_bucket_triggger]
}


resource "aws_dynamodb_table" "dynamo_airports" {
  hash_key = ""
  name = ""
  attribute {
    name = ""
    type = ""
  }
}
output "print_bucket_info" {
  value = aws_s3_bucket.lb1.arn
}
output "print_lambda_info" {
  value = aws_lambda_function.mylb.arn
}

module "appbuckets" {
  source = "./appbuckets"
  bucketvar = "anyvarofyours"
}
module  "apprds" {
  source = "./rds"
  port = var.rds_port_d1
}

output "buckwar" {
  value = module.appbuckets.print_buck_var
}

output "print_moddata" {
  value = module.apprds.db_arn
}




