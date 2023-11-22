resource "azurerm_key_vault" "example" {
  name                        = "keyvault${random_integer.ri.result}"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List",
    ]

    secret_permissions = [
      "Set",
      "Get",
      "List",
    ]
  }
}

resource "azurerm_key_vault_secret" "example" {
  name         = "ssh-key"
  value        = file("/home/hazem/Github/Azure_Resources/CodiLime-AKS/Codi_key")
  key_vault_id = azurerm_key_vault.example.id
}

resource "random_integer" "ri" {
  min = 1
  max = 9999
}
