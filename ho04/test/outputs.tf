output "network_interface_private_ip" {
  description = "Private IP addresses of the vm nics"
  value       = azurerm_network_interface.nic.*.private_ip_address
}

output "network_vm_public_ip" {
  description = "Private IP addresses of the vm nics"
  value       = azurerm_public_ip.publicip.ip_address
}
