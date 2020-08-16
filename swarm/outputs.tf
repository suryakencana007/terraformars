output "manager_ip_addresses" {
  value = aws_eip.managers.*.public_ip
}