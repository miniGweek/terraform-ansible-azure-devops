resource "azurerm_resource_group" "core_rg" {
  name     = "${local.prefixcore}-rg"
  location = local.location.fullname
}

resource "azurerm_virtual_network" "main" {
  name                = "${local.prefixcore}-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.core_rg.location
  resource_group_name = azurerm_resource_group.core_rg.name
}

resource "azurerm_subnet" "internal" {
  name                 = "${local.prefixcore}-internal-snet"
  resource_group_name  = azurerm_resource_group.core_rg.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "core_kv" {
  name                        = "${local.prefixcore}-kv"
  location                    = azurerm_resource_group.core_rg.location
  resource_group_name         = azurerm_resource_group.core_rg.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_enabled         = true
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
      "list",
      "set"
    ]

    storage_permissions = [
      "get",
    ]
  }

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"

    ip_rules = [var.my_temp_machine_ip]
  }

  tags = local.tags
}

resource "azurerm_key_vault_secret" "secret_vm_login" {
  name         = "vm--login"
  value        = var.my_vm_login
  key_vault_id = azurerm_key_vault.core_kv.id

  tags = local.tags
}

resource "azurerm_key_vault_secret" "secret_vm_password" {
  name         = "vm--password"
  value        = var.my_vm_password
  key_vault_id = azurerm_key_vault.core_kv.id

  tags = local.tags
}
