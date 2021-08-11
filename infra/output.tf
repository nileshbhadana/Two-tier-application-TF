output "Web-Server-DNS" {
  description = "Public DNS of Webserver"
  value       = aws_instance.web-server.public_dns
}

output "Web-Server-IP" {
  description = "Public IP of Webserver"
  value       = aws_instance.web-server.public_ip
}

output "VPC-Id" {
  description = "ID for the VPC created"
  value       = aws_vpc.vpc.id
}

output "NAT-Ip" {
  description = "IP of NAT Gateway created"
  value       = aws_eip.nat_ip.public_ip
}