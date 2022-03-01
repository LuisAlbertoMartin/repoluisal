## Azure bastion

# Public IP of the bastion
resource "azurerm_public_ip" "bastion" {
  count               = var.azure_bastion_enabled
  name                = format("%s-bastion-public-ip", var.resource_prefix)
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  allocation_method   = "Static"
  sku                 = "Standard"
  lifecycle {
    ignore_changes = [tags]
  }
}

# Bastion subnet
resource "azurerm_subnet" "bastion" {
  count                = var.azure_bastion_enabled
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.azurerm_virtual_network_bastion_vnet_name
  address_prefixes     = var.azurerm_subnets_internal_bastion_cidr
}

# Bastion definition
resource "azurerm_bastion_host" "vm" {
  count               = var.azure_bastion_enabled
  name                = format("%s-bastion", var.resource_prefix)
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location

  ip_configuration {
    name                 = format("%s-ip-bastion-config", var.resource_prefix)
    subnet_id            = azurerm_subnet.bastion[count.index].id
    public_ip_address_id = azurerm_public_ip.bastion[count.index].id
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

# Enable audit log for accesses to the bastion
resource "azurerm_monitor_diagnostic_setting" "bastion" {
  count                      = var.azure_bastion_enabled
  name                       = format("%s-bastion-access-logs", var.resource_prefix)
  target_resource_id         = azurerm_bastion_host.vm[count.index].id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  log {
    category = "BastionAuditLogs"
    enabled  = true

    retention_policy {
      enabled = false
    }
  }
}
