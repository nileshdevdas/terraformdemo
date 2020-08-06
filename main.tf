provider "aws" {
  region = "ap-south-1"
}
resource "aws_s3_bucket" "lb1" {
  bucket =var.lambda_bucket
}
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
}
output "print_bucket_info" {
  value = aws_s3_bucket.lb1.arn
}
output "print_lambda_info" {
  value = aws_lambda_function.mylb.arn
}
