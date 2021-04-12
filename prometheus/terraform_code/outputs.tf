output "PrometheusServer" {
  description = "Public Ip Address of Prometheus Server"
  value       = aws_instance.PrometheusServer.public_ip
}

output "OtherServers" {
  description = "Public Ip Address of Ec2 Vms"
  value = { for server in aws_instance.Servers :
    server.tags["Name"] => server.public_ip
  }
}
