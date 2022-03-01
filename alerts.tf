# Action group definition
resource "azurerm_monitor_action_group" "vm" {
  count               = var.action_group_creation_enabled ? 1 : 0
  name                = format("%s-action-group", var.resource_group_name)
  resource_group_name = var.resource_group_name
  short_name          = "alerts-act"

  email_receiver {
    name                    = "EmatilToOwner"
    email_address           = var.action_group_email_address_owner
    use_common_alert_schema = true
  }

  email_receiver {
    name                    = "EmatilToTech"
    email_address           = var.action_group_email_address_tech
    use_common_alert_schema = true
  }


  lifecycle {
    ignore_changes = [tags]
  }
}

# Alert rules
resource "azurerm_monitor_metric_alert" "cpu" {
  count               = var.alert_for_metric_cpu_enabled ? var.instance_count : 0
  name                = format("%s - VM CPU percentage is greater than 90", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  resource_group_name = var.resource_group_name
  scopes              = [element(azurerm_linux_virtual_machine.vm.*.id, count.index)]
  description         = format("The CPU of the machine %s, as indicated in the Insights of the alert, has exceeded 90 percent of use.", element(azurerm_linux_virtual_machine.vm.*.name, count.index))

  severity      = 2
  enabled       = true
  frequency     = "PT5M"
  window_size   = "PT5M"
  auto_mitigate = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = var.action_group_creation_enabled ? azurerm_monitor_action_group.vm[0].id : data.azurerm_monitor_action_group.project[0].id
  }

  action {
    action_group_id = var.action_group_seguridad_digital_team
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_metric_alert" "iops" {
  count               = var.alert_for_metric_iops_enabled ? var.instance_count : 0
  name                = format("%s - VMs 90 percent IOPs", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  resource_group_name = var.resource_group_name
  scopes              = [element(azurerm_linux_virtual_machine.vm.*.id, count.index)]
  description         = format("The virtual machine %s indicated in the insights has reached 90 percent of IOPs consumption", element(azurerm_linux_virtual_machine.vm.*.name, count.index))

  severity      = 3
  enabled       = true
  frequency     = "PT5M"
  window_size   = "PT5M"
  auto_mitigate = true

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Data Disk IOPS Consumed Percentage"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 90
  }

  action {
    action_group_id = var.action_group_creation_enabled ? azurerm_monitor_action_group.vm[0].id : data.azurerm_monitor_action_group.project[0].id
  }

  action {
    action_group_id = var.action_group_seguridad_digital_team
  }

  lifecycle {
    ignore_changes = [tags]
  }
}


resource "azurerm_monitor_activity_log_alert" "vm-restarted" {
  count               = var.alert_for_metric_vm_restarted_enabled ? var.instance_count : 0
  name                = format("%s - VM Restarted", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  resource_group_name = var.resource_group_name
  scopes              = [local.resource_group_id]
  description         = format("The virtual machine %s has been rebooted.", element(azurerm_linux_virtual_machine.vm.*.name, count.index))

  criteria {
    resource_id    = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
    operation_name = "Microsoft.Compute/virtualMachines/restart/action"
    category       = "Administrative"
  }
  action {
    action_group_id = var.action_group_creation_enabled ? azurerm_monitor_action_group.vm[0].id : data.azurerm_monitor_action_group.project[0].id
  }

  action {
    action_group_id = var.action_group_seguridad_digital_team
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_activity_log_alert" "vm-stopped" {
  count               = var.alert_for_metric_vm_stopped_enabled ? var.instance_count : 0
  name                = format("%s - VM Turned off", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  resource_group_name = var.resource_group_name
  scopes              = [local.resource_group_id]
  description         = format("The virtual machine %s has been stopped.", element(azurerm_linux_virtual_machine.vm.*.name, count.index))

  criteria {
    resource_id    = element(azurerm_linux_virtual_machine.vm.*.id, count.index)
    operation_name = "Microsoft.Compute/virtualMachines/deallocate/action"
    category       = "Administrative"
  }
  action {
    action_group_id = var.action_group_creation_enabled ? azurerm_monitor_action_group.vm[0].id : data.azurerm_monitor_action_group.project[0].id
  }

  action {
    action_group_id = var.action_group_seguridad_digital_team
  }

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "azurerm_monitor_scheduled_query_rules_alert" "disk-occupied" {
  count               = var.alert_for_metric_disk_occupied_enabled ? var.instance_count : 0
  name                = format("%s - VM disk percentage free space is less than 10", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  resource_group_name = var.resource_group_name
  location            = var.resource_group_location
  description         = format("The virtual machine %s indicated in the Insights of the alert has the disk at more than 90 percent occupancy.", element(azurerm_linux_virtual_machine.vm.*.name, count.index))
  enabled             = true
  throttling          = 240

  action {
    action_group  = [var.action_group_creation_enabled ? azurerm_monitor_action_group.vm[0].id : data.azurerm_monitor_action_group.project[0].id, var.action_group_seguridad_digital_team]
    email_subject = "The virtual machine ${element(azurerm_linux_virtual_machine.vm.*.name, count.index)} has reached 90 percent disk space occupied."
  }

  data_source_id = element(azurerm_linux_virtual_machine.vm.*.id, count.index)

  # Query definition
  # VM Insights examples: https://docs.microsoft.com/es-es/azure/azure-monitor/vm/vminsights-alerts
  query       = <<-QUERY
  // Virtual Machine free disk space
  // Show the latest report of free disk space, per instance
  InsightsMetrics
    | where Name == "FreeSpacePercentage"
    | where Computer == "${element(azurerm_linux_virtual_machine.vm.*.name, count.index)}"
    | where Val <= 10
    | summarize arg_max(TimeGenerated, *) by Tags
    // arg_max over TimeGenerated returns the latest record
    | project TimeGenerated, Computer, Val, Tags

  QUERY
  severity    = 2
  frequency   = 5
  time_window = 15
  trigger {
    operator  = "GreaterThan"
    threshold = 0
  }

  lifecycle {
    ignore_changes = [tags]
  }
}
