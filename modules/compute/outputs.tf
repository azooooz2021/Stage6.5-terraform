output "chromadb_vm_id" {
  value = azurerm_linux_virtual_machine.chromadb_vm.id
}

output "chromadb_public_ip" {
  value = azurerm_public_ip.chromadb.ip_address
}

output "vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.chatbot_vmss.id
}

output "vmss_principal_id" {
  value = azurerm_linux_virtual_machine_scale_set.chatbot_vmss.identity[0].principal_id
}
