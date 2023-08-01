output "ssh_command" {
  value = "ssh -i ~/.ssh/id_rsa adminuser@${azurerm_public_ip.external_ip.ip_address}"
}