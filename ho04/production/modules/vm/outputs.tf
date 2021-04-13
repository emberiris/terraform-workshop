output "vm_name"{
    value = "${azurerm_virtual_machine.vm.name}"
}

output "adm_pswd"{
    value = "${azurerm_virtual_machine.vm.os_profile[*].admin_password}"
}