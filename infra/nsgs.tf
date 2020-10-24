
resource "azurerm_application_security_group" "dev_vm_asg" {
  name                = "${local.prefixdev}-vm-asg"
  location            = azurerm_resource_group.dev_rg.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  tags = merge(local.tags, local.tags_dev)
}


resource "azurerm_network_security_group" "dev_vm_nsg" {
  name                = "${local.prefixdev}-vm-nsg"
  location            = azurerm_resource_group.dev_rg.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  security_rule {
    name                                       = "${local.prefixdev}-developer-rdp-in"
    priority                                   = 400
    direction                                  = "Inbound"
    access                                     = "Allow"
    protocol                                   = "Tcp"
    source_port_range                          = "*"
    source_address_prefixes                    = [var.my_temp_machine_ip]
    destination_port_range                     = "3389"
    destination_application_security_group_ids = [azurerm_application_security_group.dev_vm_asg.id]
  }

  security_rule {
    name                                       = "${local.prefixdev}-deny-vnet-in"
    priority                                   = 4000
    direction                                  = "Inbound"
    access                                     = "Deny"
    protocol                                   = "*"
    source_port_range                          = "*"
    source_address_prefix                      = "VirtualNetwork"
    destination_port_range                     = "*"
    destination_application_security_group_ids = [azurerm_application_security_group.dev_vm_asg.id]
  }

  tags = merge(local.tags, local.tags_dev)
}
