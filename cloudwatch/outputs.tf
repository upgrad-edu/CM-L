output "public_ip" {
  description = "public ip of instance"
  value       = aws_instance.cmldemo.public_ip
}
