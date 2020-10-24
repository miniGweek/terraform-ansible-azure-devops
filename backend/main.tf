resource "azurerm_resource_group" "backend_rg" {
  name     = local.resourcegroupname
  location = local.location.fullname
  tags     = local.tags
}

resource "azurerm_storage_account" "backend_sa" {
  name                      = "${replace(lower(local.prefix), "-", "")}sa"
  resource_group_name       = azurerm_resource_group.backend_rg.name
  location                  = local.location.fullname
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  enable_https_traffic_only = true
  access_tier               = "Hot"
  account_replication_type  = "LRS"
  allow_blob_public_access  = false
}

resource "azurerm_storage_container" "backend_ct" {
  name                 = "${lower(local.prefix)}-tf-state-ct"
  storage_account_name = azurerm_storage_account.backend_sa.name
}

data "azurerm_storage_account_sas" "backend_state_token" {
  connection_string = azurerm_storage_account.backend_sa.primary_connection_string
  https_only        = true

  resource_types {
    service   = true
    container = true
    object    = true
  }

  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }

  start  = timestamp()
  expiry = timeadd(timestamp(), "168h")

  permissions {
    read    = true
    write   = true
    add     = true
    create  = true
    delete  = true
    list    = true
    process = true
    update  = true
  }
}

resource "null_resource" "write_backend_config" {
  depends_on = [azurerm_storage_container.backend_ct]

  provisioner "local-exec" {
    command = <<EOT
            Add-Content -Value 'storage_account_name = "${azurerm_storage_account.backend_sa.name}"' -Path backend-config.txt
            Add-Content -Value  'container_name = "${azurerm_storage_container.backend_ct.name}"' -Path backend-config.txt
            Add-Content -Value  'key = "terraform.tfstate"' -Path backend-config.txt
            Add-Content -Value  'sas_token = "${data.azurerm_storage_account_sas.backend_state_token.sas}"' -Path backend-config.txt
            EOT

    interpreter = ["PowerShell", "-Command"]
  }
}
