
terraform {
  backend "azurerm" {
    resource_group_name  = "learn-terraform-auea-rg"
    storage_account_name = "learnansibleaueasa"
    container_name       = "learn-ansible-auea-tf-state-ct"
    key                  = "lrn-core.tfstate"
  }
}

