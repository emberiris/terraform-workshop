module "test_environment"{
    source = "./modules"
rsg_name                            = "terraform_ho02"
prefix                              = "ho04"
vnet_cidr                           = ["10.0.0.0/16"]
subnet_cidrs                        = ["10.0.1.0/24"]
pip_allocation                      = "Static"
private_ip_alloc                    = "dynamic"
vm_size                             = "Standard_DS1_v2"
enabled_for_disk_encryption         = true
soft_delete_retention_days          = 7
purge_protection_enabled            = false
kvt_sku                             = "premium"
user_data_file                      = "user-data.sh"
}