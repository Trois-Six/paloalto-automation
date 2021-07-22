output "whoami_instance_id" {
  value = aws_instance.whoami.id
}

output "whoami_ip" {
  value = var.ip
}