## Variables definition

# Prefix
variable "resource_prefix" {
  description = "Prefix of the resources"
  type        = list(string)
}

# Resource group
variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "resource_group_location" {
  description = "Location of the resource group"
  type        = string
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription id"
}

variable "tenant_id" {
  type        = string
  description = "The tenant id of the Azure Active Directory"
}

# Networking
variable "subnet_id" {
  description = "ID of the subnet of virtual machine instances"
  type        = string
}

variable "azurerm_virtual_network_bastion_vnet_name" {
  description = "Name of virtual network where create the subnet for bastion host"
  type        = string
  default     = ""
}

variable "azurerm_subnets_internal_bastion_cidr" {
  description = "CIDR of the bastion network. E.g. [10.0.3.224/27]"
  type        = list(string)
  default     = []
}

# Log analytics
variable "log_analytics_workspace_id" {
  description = "ID of the log analytics workspace"
  type        = string
}

variable "log_analytics_primary_shared_key" {
  description = "Primary shared key of the log analytics"
  type        = string
}

# Compute
variable "instance_count" {
  description = "Number of virtual machine instances"
  type        = number
  default     = 1
}

variable "instance_size" {
  description = "Size of virtual machine instances"
  type        = string
}

variable "admin_username" {
  description = "Admin username of virtual machine instances"
  type        = string
}

variable "admin_password" {
  description = "Admin password of virtual machine instances"
  type        = string
}

variable "bootdiagnostics_storage_account_uri" {
  description = "Storage account uri for save the boot diagnostic of virtual machine instances"
  type        = string
}

variable "os_disk_caching" {
  description = "Type of the OS disk caching of virtual machine instances"
  type        = string
  default     = "ReadWrite"
}

variable "os_disk_storage_account_type" {
  description = "Type of storage account for the swap os disk of virtual machine instances"
  type        = string
}

variable "os_disk_size_gb" {
  description = "Size of the Swap OS disk"
  type        = number
  default     = null
}

variable "data_disk_enabled" {
  description = "Enable (true) or disable (false) the creation of the data disk"
  type        = bool
  default     = false
}

variable "data_disk_storage_account_type" {
  description = "Type of storage account for the data disk of virtual machine instances"
  type        = string
}

variable "data_disk_size_gb" {
  description = "Size of the data disk"
  type        = number
}

variable "vm_extensions_enabled" {
  description = "Flag to enable (1) or disable (0) the installation of extensions on virtual machine"
  type        = bool
  default     = true
}

variable "source_image_id" {
  description = "The ID of the custom image which this Virtual Machine should be created from. Only passed when source_image_reference was not specified"
  type        = string
  default     = null
}

variable "source_image_reference" {
  description = "The definition of the virtual machine image. Only passed when source_image_id was not specified"
  type = set(object(
    {
      offer     = string
      publisher = string
      sku       = string
      version   = string
    }
  ))
  default = []
}

variable "vm_public_ip_enabled" {
  description = "Flag to enable (1) or disable (0) the creation of public ip on virtual machine"
  type        = bool
  default     = false
}

# VM Auto-shutdown
variable "auto_shutdown_enabled" {
  description = "Enable or disable auto-shutdown of the virtual machine instances"
  type        = bool
  default     = false
}

variable "auto_shutdown_daily_recurrence_time" {
  description = "Time recurrence for auto-shutdown of the virtual machine instances"
  type        = string
}

variable "auto_shutdown_timezone" {
  description = "Timezone for auto-shutdown of the virtual machine instances"
  type        = string
}

# Bastion
variable "azure_bastion_enabled" {
  description = "Flag to enable (1) or disable (0) azure bastion host"
  type        = number
  default     = 0
}

# Alerts
variable "action_group_creation_enabled" {
  description = "Flag to enable (true) or disable (false) the creation of the action group"
  type        = bool
  default     = false
}

variable "action_group_existing_name" {
  description = "The name of the action group when it already exists"
  default     = "action_group_fake"
}

variable "action_group_existing_resource_group_name" {
  description = "The name of the resource group where action group was created when it already exists"
  default     = "action_group_resource_group_fake"
}

variable "action_group_seguridad_digital_team" {
  description = "The name of the action group for teams"
  type        = string
}

variable "action_group_email_address_owner" {
  description = "Email address of the owner of the resource group to send alerts"
  type        = string
}

variable "action_group_email_address_tech" {
  description = "Email address of the tech of the resource group to send alerts"
  type        = string
}

variable "alert_for_metric_cpu_enabled" {
  description = "Flag to enable (true) or disable (false) the creation of the alert"
  type        = bool
  default     = true
}

variable "alert_for_metric_iops_enabled" {
  description = "Flag to enable (true) or disable (false) the creation of the alert"
  type        = bool
  default     = true
}

variable "alert_for_metric_vm_restarted_enabled" {
  description = "Flag to enable (true) or disable (false) the creation of the alert"
  type        = bool
  default     = true
}

variable "alert_for_metric_vm_stopped_enabled" {
  description = "Flag to enable (true) or disable (false) the creation of the alert"
  type        = bool
  default     = true
}

variable "alert_for_metric_disk_occupied_enabled" {
  description = "Flag to enable (true) or disable (false) the creation of the alert"
  type        = bool
  default     = true
}

# Backups
variable "backup_policy_vm_enabled" {
  description = "Flag to enable (true) or disable (false) backup of vm to recovery service vault"
  type        = bool
  default     = false
}

variable "backup_recovery_vault_resource_group_name" {
  description = "Resource group of recovery service vault"
  type        = string
}

variable "backup_recovery_vault_name" {
  description = "Name of recovery service vault"
  type        = string
}

variable "backup_policy_vm_name" {
  description = "Name of policy of the recovery service vault"
  type        = string
}

# IAM
# Enable when you pass the email of the users to configure iam
variable "vm_iam_role_enabled" {
  description = "Flag to enable (true) or disable (false) the assignment of the iam roles according email of users"
  type        = bool
  default     = false
}

variable "vm_iam_role_name" {
  description = "Name of iam role to assign"
  type        = string
  default     = null
}

variable "vm_iam_principal_id_list" {
  description = "List of principals (users, groups or service principals) to assign according email of users"
  type        = list(string)
  default     = []
}

# Enable when you pass the object_ids to configure iam
variable "vm_iam_role_object_id_enabled" {
  description = "Flag to enable (true) or disable (false) the assignment of the iam roles according object_ids"
  type        = bool
  default     = false
}

variable "vm_iam_principal_object_id_list" {
  description = "List of principals (users, groups or service principals) to assign according object_ids"
  type        = list(string)
  default     = []
}
