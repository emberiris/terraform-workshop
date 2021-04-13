resource "azurerm_key_vault" "secrets_vault" {
  name                        = "${var.prefix}-akv"
  location                    = data.azurerm_resource_group.rsg_datasource.location
  resource_group_name         = data.azurerm_resource_group.rsg_datasource.name
  enabled_for_disk_encryption = var.enabled_for_disk_encryption
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = var.soft_delete_retention_days
  purge_protection_enabled    = var.purge_protection_enabled

  sku_name                    = var.kvt_sku

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}

resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
  min_lower         = 3
  min_numeric       = 3
  min_upper         = 3
  min_special       = 3
}

resource "azurerm_key_vault_secret" "vm_password" {
  name         = "myUsername"
  value        = random_password.password.result
  key_vault_id = azurerm_key_vault.secrets_vault.id
}