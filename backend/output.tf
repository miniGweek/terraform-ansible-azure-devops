    ## OUTPUT

    output "storage_account_name" {
        value = azurerm_storage_account.backend_sa.name
    }

    output "resource_group_name" {
        value = azurerm_resource_group.backend_rg.name
    }