provider "azurerm" {
  version = ">= 2.28.0"
  features {}
}

terraform {
  required_version = ">= 0.13.3"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}
