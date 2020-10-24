data "azurerm_key_vault" "core_kv" {
  name                = local.secret_keyvault_name
  resource_group_name = local.core_rg
}

data "azurerm_key_vault_secret" "secret_vm_login" {
  name         = local.secret_vm_login
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

data "azurerm_key_vault_secret" "secret_vm_password" {
  name         = local.secret_vm_password
  key_vault_id = data.azurerm_key_vault.core_kv.id
}

data "azurerm_subnet" "internal_snet" {
  name                 = local.core_internal_subnet
  virtual_network_name = local.core_vnet
  resource_group_name  = local.core_rg
}
