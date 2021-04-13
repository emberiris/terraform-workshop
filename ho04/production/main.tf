module "vm_env"{
    source = "./modules/vm"

    vm_name = "test"
    location = "westeurope"
    rsg = "terraform_ho02"
    network_interface_id = [azurerm_network_interface.nic.id] #module.nombre_modulo.nombre_variable_exportada
    vm_size = "Standard_DS1_v2"
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04.0-LTS"
    version_image = "latest"
    adm_username = "user_master"
    adm_pswd = "Test00!Test00!Test00!"
    disable_password_authentication = false
    dependencies = []
}
