
resource "azurerm_resource_group" "dev_rg" {
  name     = "${local.prefix}-dev-rg"
  location = local.location.fullname
}

resource "azurerm_network_interface" "main" {
  name                = "${local.prefixdev}-nic"
  location            = azurerm_resource_group.dev_rg.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  ip_configuration {
    name                          = "internalipconfig"
    subnet_id                     = data.azurerm_subnet.internal_snet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.dev_vm_ip.id
  }
}

resource "azurerm_network_interface_application_security_group_association" "dev_vm_nic_asg" {
  network_interface_id          = azurerm_network_interface.main.id
  application_security_group_id = azurerm_application_security_group.dev_vm_asg.id
}

resource "azurerm_windows_virtual_machine" "main" {
  name                  = "${local.prefixdev}-vm"
  computer_name         = "lrnaueadev1"
  location              = azurerm_resource_group.dev_rg.location
  resource_group_name   = azurerm_resource_group.dev_rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  size                  = "Standard_A2_v2"
  admin_username        = data.azurerm_key_vault_secret.secret_vm_login.value
  admin_password        = data.azurerm_key_vault_secret.secret_vm_password.value

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
    name                 = "${local.prefixdev}-osdisk"
  }

  tags = merge(local.tags, local.tags_dev)
}


resource "azurerm_public_ip" "dev_vm_ip" {
  name                = "${local.prefixdev}-vm-pip"
  resource_group_name = azurerm_resource_group.dev_rg.name
  location            = azurerm_resource_group.dev_rg.location
  allocation_method   = "Dynamic"

  tags = merge(local.tags, local.tags_dev)
}

output "publicip_dev_vm" {
  value = azurerm_public_ip.dev_vm_ip.ip_address
}
