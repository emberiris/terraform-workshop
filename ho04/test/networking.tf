resource "azurerm_virtual_network" "vnet" {
    name                = "${var.prefix}-vnet"
    address_space       = var.vnet_cidr
    location            = data.azurerm_resource_group.rsg_datasource.location
    resource_group_name = data.azurerm_resource_group.rsg_datasource.name
}

resource "azurerm_subnet" "subnet" {
  name                 = "${var.prefix}-subnet"
  resource_group_name  = data.azurerm_resource_group.rsg_datasource.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = var.subnet_cidrs
}

resource "azurerm_public_ip" "publicip" {
  name                = "${var.prefix}-pip"
  location            = data.azurerm_resource_group.rsg_datasource.location
  resource_group_name = data.azurerm_resource_group.rsg_datasource.name
  allocation_method   = var.pip_allocation
}

resource "azurerm_network_interface" "nic" {
  name                      = "${var.prefix}-nic"
  location                  = data.azurerm_resource_group.rsg_datasource.location
  resource_group_name       = data.azurerm_resource_group.rsg_datasource.name

  ip_configuration {
    name                          = "${var.prefix}-ipconf"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = var.private_ip_alloc
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}