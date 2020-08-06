resource "aws_db_instance" "myinst" {
  instance_class = "t2.micro"
  port = var.port
}

output "db_arn" {
  value = aws_db_instance.myinst.arn
}