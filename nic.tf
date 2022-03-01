## Network interfaces definition and associations

# Public IPs
resource "azurerm_public_ip" "vm" {
  count               = var.vm_public_ip_enabled ? var.instance_count : 0
  name                = format("%s-pip", element(var.resource_prefix, count.index))
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"

  lifecycle {
    ignore_changes = [tags]
  }

}

# NIC
resource "azurerm_network_interface" "vm" {
  count               = var.instance_count
  name                = format("%s-nic", element(var.resource_prefix, count.index))
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                          = format("%s-nic-ipc", element(var.resource_prefix, count.index))
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = var.vm_public_ip_enabled ? azurerm_public_ip.vm[count.index].id : null
  }

  lifecycle {
    ignore_changes = [tags]
  }

}
