## Virtual machine definition

# Virtual machine instances
resource "azurerm_linux_virtual_machine" "vm" {
  count                      = var.instance_count
  name                       = format("%s", element(var.resource_prefix, count.index))
  resource_group_name        = var.resource_group_name
  location                   = var.resource_group_location
  size                       = var.instance_size
  admin_username             = var.admin_username
  admin_password             = var.admin_password
  network_interface_ids      = [element(azurerm_network_interface.vm.*.id, count.index)]
  encryption_at_host_enabled = false

  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = var.bootdiagnostics_storage_account_uri
  }

  os_disk {
    name                 = format("%s-OsDisk", element(var.resource_prefix, count.index))
    caching              = var.os_disk_caching
    storage_account_type = var.os_disk_storage_account_type
    disk_size_gb         = (var.os_disk_size_gb != null) ? var.os_disk_size_gb : null
  }

  source_image_id = var.source_image_id

  dynamic "source_image_reference" {
    for_each = var.source_image_reference
    content {
      offer     = source_image_reference.value["offer"]
      publisher = source_image_reference.value["publisher"]
      sku       = source_image_reference.value["sku"]
      version   = source_image_reference.value["version"]
    }
  }

  custom_data = base64encode(templatefile("${path.module}/templates/custom_data.sh", {
    project = var.resource_prefix
  }))

  lifecycle {
    ignore_changes = [tags]
  }
}

# Extension for oms agent
resource "azurerm_virtual_machine_extension" "oms-agent" {
  count                      = var.vm_extensions_enabled ? var.instance_count : 0
  name                       = "OmsAgentForLinux"
  virtual_machine_id         = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
  publisher                  = "Microsoft.EnterpriseCloud.Monitoring"
  type                       = "OmsAgentForLinux"
  type_handler_version       = "1.13"
  auto_upgrade_minor_version = true

  settings = <<SETTINGS
  {
     "workspaceId": "${var.log_analytics_workspace_id}"
  }
SETTINGS

  protected_settings = <<SETTINGS
  {
      "workspaceKey": "${var.log_analytics_primary_shared_key}"
  }
SETTINGS

  lifecycle {
    ignore_changes = [tags]
  }
}

# Extension for dependency agent
resource "azurerm_virtual_machine_extension" "dependency-agent" {
  count                      = var.vm_extensions_enabled ? var.instance_count : 0
  name                       = "DependencyAgentLinux"
  virtual_machine_id         = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
  publisher                  = "Microsoft.Azure.Monitoring.DependencyAgent"
  type                       = "DependencyAgentLinux"
  type_handler_version       = "9.5"
  auto_upgrade_minor_version = true

  lifecycle {
    ignore_changes = [tags]
  }

}

# VM Auto-shutdown
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm" {
  count              = var.instance_count
  virtual_machine_id = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
  location           = var.resource_group_location
  enabled            = var.auto_shutdown_enabled

  daily_recurrence_time = var.auto_shutdown_daily_recurrence_time
  timezone              = var.auto_shutdown_timezone

  notification_settings {
    enabled         = false
    time_in_minutes = "60"
    webhook_url     = "https://sample-webhook-url.example.com"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [azurerm_linux_virtual_machine.vm]

}

# Managed data disk
resource "azurerm_managed_disk" "data-disk" {
  count                = var.data_disk_enabled ? var.instance_count : 0
  name                 = format("%s-DataDisk", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  resource_group_name  = var.resource_group_name
  location             = var.resource_group_location
  storage_account_type = var.data_disk_storage_account_type
  create_option        = "Empty"
  disk_size_gb         = var.data_disk_size_gb

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_virtual_machine_data_disk_attachment" "data-disk" {
  count              = var.data_disk_enabled ? var.instance_count : 0
  managed_disk_id    = azurerm_managed_disk.data-disk[count.index].id
  virtual_machine_id = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
  lun                = count.index + 1
  caching            = "ReadWrite"
}
