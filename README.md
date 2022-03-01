## Brief

Terraform module to create linux virtual machines on Azure

## Requirements

Terraform version at least 0.14

## Providers

| Name | Version |
|------|---------|
| azuread | 1.5.0 |
| azurerm | 2.59.0 |
| template | 2.2.0 |
| random | 3.1.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| action\_group\_creation\_enabled | Flag to enable (true) or disable (false) the creation of the action group | `bool` | `false` | no |
| action\_group\_email\_address\_owner | Email address of the owner of the resource group to send alerts | `string` | n/a | yes |
| action\_group\_email\_address\_tech | Email address of the tech of the resource group to send alerts | `string` | n/a | yes |
| action\_group\_existing\_name | The name of the action group when it already exists | `string` | `"action_group_fake"` | no |
| action\_group\_existing\_resource\_group\_name | The name of the resource group where action group was created when it already exists | `string` | `"action_group_resource_group_fake"` | no |
| action\_group\_seguridad\_digital\_team | The name of the action group for teams | `string` | n/a | yes |
| admin\_password | Admin password of virtual machine instances | `string` | n/a | yes |
| admin\_username | Admin username of virtual machine instances | `string` | n/a | yes |
| alert\_for\_metric\_cpu\_enabled | Flag to enable (true) or disable (false) the creation of the alert | `bool` | `true` | no |
| alert\_for\_metric\_disk\_occupied\_enabled | Flag to enable (true) or disable (false) the creation of the alert | `bool` | `true` | no |
| alert\_for\_metric\_iops\_enabled | Flag to enable (true) or disable (false) the creation of the alert | `bool` | `true` | no |
| alert\_for\_metric\_vm\_restarted\_enabled | Flag to enable (true) or disable (false) the creation of the alert | `bool` | `true` | no |
| alert\_for\_metric\_vm\_stopped\_enabled | Flag to enable (true) or disable (false) the creation of the alert | `bool` | `true` | no |
| auto\_shutdown\_daily\_recurrence\_time | Time recurrence for auto-shutdown of the virtual machine instances | `string` | n/a | yes |
| auto\_shutdown\_enabled | Enable or disable auto-shutdown of the virtual machine instances | `bool` | `false` | no |
| auto\_shutdown\_timezone | Timezone for auto-shutdown of the virtual machine instances | `string` | n/a | yes |
| azure\_bastion\_enabled | Flag to enable (1) or disable (0) azure bastion host | `number` | `0` | no |
| azurerm\_subnets\_internal\_bastion\_cidr | CIDR of the bastion network. E.g. [10.0.3.224/27] | `list(string)` | `[]` | no |
| azurerm\_virtual\_network\_bastion\_vnet\_name | Name of virtual network where create the subnet for bastion host | `string` | `""` | no |
| backup\_policy\_vm\_enabled | Flag to enable (true) or disable (false) backup of vm to recovery service vault | `bool` | `false` | no |
| backup\_policy\_vm\_name | Name of policy of the recovery service vault | `string` | n/a | yes |
| backup\_recovery\_vault\_name | Name of recovery service vault | `string` | n/a | yes |
| backup\_recovery\_vault\_resource\_group\_name | Resource group of recovery service vault | `string` | n/a | yes |
| bootdiagnostics\_storage\_account\_uri | Storage account uri for save the boot diagnostic of virtual machine instances | `string` | n/a | yes |
| data\_disk\_enabled | Enable (true) or disable (false) the creation of the data disk | `bool` | `false` | no |
| data\_disk\_size\_gb | Size of the data disk | `number` | n/a | yes |
| data\_disk\_storage\_account\_type | Type of storage account for the data disk of virtual machine instances | `string` | n/a | yes |
| instance\_count | Number of virtual machine instances | `number` | `1` | no |
| instance\_size | Size of virtual machine instances | `string` | n/a | yes |
| log\_analytics\_primary\_shared\_key | Primary shared key of the log analytics | `string` | n/a | yes |
| log\_analytics\_workspace\_id | ID of the log analytics workspace | `string` | n/a | yes |
| os\_disk\_caching | Type of the OS disk caching of virtual machine instances | `string` | `"ReadWrite"` | no |
| os\_disk\_size\_gb | Size of the Swap OS disk | `number` | `null` | no |
| os\_disk\_storage\_account\_type | Type of storage account for the swap os disk of virtual machine instances | `string` | n/a | yes |
| resource\_group\_location | Location of the resource group | `string` | n/a | yes |
| resource\_group\_name | Name of the resource group | `string` | n/a | yes |
| resource\_prefix | Prefix of the resources | `list(string)` | n/a | yes |
| source\_image\_id | The ID of the custom image which this Virtual Machine should be created from. Only passed when source\_image\_reference was not specified | `string` | `null` | no |
| source\_image\_reference | The definition of the virtual machine image. Only passed when source\_image\_id was not specified | <pre>set(object(<br>    {<br>      offer     = string<br>      publisher = string<br>      sku       = string<br>      version   = string<br>    }<br>  ))</pre> | `[]` | no |
| subnet\_id | ID of the subnet of virtual machine instances | `string` | n/a | yes |
| subscription\_id | The Azure subscription id | `string` | n/a | yes |
| tenant\_id | The tenant id of the Azure Active Directory | `string` | n/a | yes |
| vm\_extensions\_enabled | Flag to enable (1) or disable (0) the installation of extensions on virtual machine | `bool` | `true` | no |
| vm\_iam\_principal\_id\_list | List of principals (users, groups or service principals) to assign according email of users | `list(string)` | `[]` | no |
| vm\_iam\_principal\_object\_id\_list | List of principals (users, groups or service principals) to assign according object\_ids | `list(string)` | `[]` | no |
| vm\_iam\_role\_enabled | Flag to enable (true) or disable (false) the assignment of the iam roles according email of users | `bool` | `false` | no |
| vm\_iam\_role\_name | Name of iam role to assign | `string` | `null` | no |
| vm\_iam\_role\_object\_id\_enabled | Flag to enable (true) or disable (false) the assignment of the iam roles according object\_ids | `bool` | `false` | no |
| vm\_public\_ip\_enabled | Flag to enable (1) or disable (0) the creation of public ip on virtual machine | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| azuread\_users\_objects\_ids | n/a |
| linux\_virtual\_machine\_id | The id of the the virtual machines |
| linux\_virtual\_machine\_name | The name of the the virtual machines |
| private\_ip\_address | The private ip addresses of the virtual machines |
| public\_ip\_address | Public ip released |


## Configuration example for projects

<b>provider.tf</b>
```
## Provider versions and configurations

# Set versions
terraform {
  required_version = ">= 0.14"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.59.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "=2.2.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "=3.1.0"
    }
    azuread = {
      source = "hashicorp/azuread"
      # To fix the warning about the `metadata_host` provider attribute update provider to 1.5.1 when is released
      version = "=1.5.0"
    }
  }
}

# Configure the providers
provider "azurerm" {
  # Configuration options
  subscription_id = var.subscription_id
 # client_id       = var.service_princial_client_id // Enable when service principal was necessary
 # client_secret   = var.service_princial_secret_id // Enable when service principal was necessary
  tenant_id       = var.tenant_id
  features {}
}

provider "azuread" {
  # Configuration options
}

# Terraform tfstate backend configuration
terraform {
  backend "azurerm" {
  }
}
```

<b>modules.tf</b>
```
module "vm-linux" {
  source                                    = "<module_path>"
  subscription_id                           = var.subscription_id
  tenant_id                                 = var.tenant_id
  resource_prefix                           = var.resource_prefix
  resource_group_name                       = var.resource_group_name
  resource_group_location                   = var.resource_group_location
  subnet_id                                 = var.subnet_id

  azure_bastion_enabled                     = var.azure_bastion_enabled
  azurerm_virtual_network_bastion_vnet_name = var.azurerm_virtual_network_bastion_vnet_name
  azurerm_subnets_internal_bastion_cidr     = var.azurerm_subnets_internal_bastion_cidr

  instance_count                        = var.instance_count
  instance_size                         = var.instance_size
  admin_username                        = var.admin_username
  bootdiagnostics_storage_account_uri   = var.bootdiagnostics_storage_account_uri
  log_analytics_workspace_id            = var.log_analytics_workspace_id
  log_analytics_primary_shared_key      = var.log_analytics_primary_shared_key
  os_disk_caching                       = var.os_disk_caching
  os_disk_storage_account_type          = var.os_disk_storage_account_type
  os_disk_size_gb                       = var.os_disk_size_gb
  data_disk_enabled                     = var.data_disk_enabled
  data_disk_storage_account_type        = var.data_disk_storage_account_type
  data_disk_size_gb                     = var.data_disk_size_gb
  vm_public_ip_enabled                  = var.vm_public_ip_enabled
  vm_extensions_enabled                 = var.vm_extensions_enabled

  source_image_id                       = var.source_image_id
  source_image_reference                = var.source_image_reference

  auto_shutdown_enabled                     = var.auto_shutdown_enabled
  auto_shutdown_daily_recurrence_time       = var.auto_shutdown_daily_recurrence_time
  auto_shutdown_timezone                    = var.auto_shutdown_timezone
  action_group_creation_enabled             = var.action_group_creation_enabled
  action_group_existing_name                = var.action_group_existing_name
  action_group_existing_resource_group_name = var.action_group_existing_resource_group_name
  action_group_email_address_owner          = var.action_group_email_address_owner
  action_group_email_address_tech           = var.action_group_email_address_tech
  action_group_seguridad_digital_team       = var.action_group_seguridad_digital_team
  alert_for_metric_cpu_enabled              = var.alert_for_metric_cpu_enabled
  alert_for_metric_iops_enabled             = var.alert_for_metric_iops_enabled
  alert_for_metric_vm_restarted_enabled     = var.alert_for_metric_vm_restarted_enabled
  alert_for_metric_vm_stopped_enabled       = var.alert_for_metric_vm_stopped_enabled
  alert_for_metric_disk_occupied_enabled    = var.alert_for_metric_disk_occupied_enabled

  backup_policy_vm_enabled                  = var.backup_policy_vm_enabled
  backup_recovery_vault_resource_group_name = var.backup_recovery_vault_resource_group_name
  backup_recovery_vault_name                = var.backup_recovery_vault_name
  backup_policy_vm_name                     = var.backup_policy_vm_name

  admin_password                      = var.admin_password

  vm_iam_role_enabled                 = var.vm_iam_role_enabled
  vm_iam_role_object_id_enabled       = var.vm_iam_role_object_id_enabled
  vm_iam_role_name                    = var.vm_iam_role_name
  vm_iam_principal_id_list            = var.vm_iam_principal_id_list
  vm_iam_principal_object_id_list     = var.vm_iam_principal_object_id_list
}

```

<b>output.tf</b>
```
output "private_ip_address" {
  description = "The private ip addresses of the virtual machines"
  value       = module.vm-linux.private_ip_address
}

output "linux_virtual_machine_name" {
  description = "The name of the the virtual machines"
  value       = module.vm-linux.linux_virtual_machine_name
}

output "linux_virtual_machine_id" {
  description = "The id of the the virtual machines"
  value       = module.vm-linux.linux_virtual_machine_id
}

output "public_ip_address" {
  description = "The public ip released"
  value       = module.vm-linux.public_ip_address
}

output "azuread_users_objects_ids" {
  description = "The object ids of the users to the iam role assignment"
  value       = module.vm-linux.azuread_users_objects_ids
}
```

<b>terraform.tfvars</b>
```
# Resource location
resource_group_name     = "<resource_group_name>"
resource_group_location = "<azure_region>"
subnet_id               = "/subscriptions/<subscription_id>/resourceGroups/<resource_group_name>/providers/Microsoft.Network/virtualNetworks/<network-name>/subnets/<subnet-name>"

# Prefix
resource_prefix         = ["VM-Name01","VM-Name02"]
instance_count          = 2

# Compute
instance_size                         = "Standard_F2"
admin_username                        = "<username>"
os_disk_storage_account_type          = "Standard_LRS"
os_disk_caching                       = "ReadWrite"
os_disk_size_gb                       = "64"
data_disk_enabled                     = true
data_disk_storage_account_type        = "Standard_LRS"
data_disk_size_gb                     = "10"

bootdiagnostics_storage_account_uri = "https://<storage_account_name>.blob.core.windows.net/"

vm_public_ip_enabled  = true
vm_extensions_enabled = true

# Note: enable "source_image_id" to create VM from custom image or enable "source_image_reference" to create it from an image offered by Azure (both are exclusive)
source_image_id = "/subscriptions/ab872b6f-41e9-4074-8c43-08e581eec91a/resourceGroups/SPWEPRGSHARED001/providers/Microsoft.Compute/galleries/SPWEPSGIMGGallery001/images/RedHat_8.2_bastionada_SOX/versions/1.0.2"

## Enable this section to use image offered by Azure
#source_image_reference = [{
#  offer     = "UbuntuServer"
#  publisher = "Canonical"
#  sku       = "18.04-LTS"
#  version   = "latest"
#}]


# Auto-shutdown of instances
# Make sure in Production if the instance can be shutdown or not
auto_shutdown_enabled               = true
auto_shutdown_daily_recurrence_time = "2300"
auto_shutdown_timezone              = "Romance Standard Time"

# Alerts
action_group_creation_enabled             = false                       // Enable or disable the creation of the action group
action_group_existing_name                = "<existing-action-group-name>" // Specify when choosing an existing action group
action_group_existing_resource_group_name = "<resource-group-existing-action-group>" // Specify when choosing an existing action group
action_group_email_address_owner          = "<owner_email_address>"
action_group_email_address_tech           = "<tech_email_address>"

// Enable or disable alerts
alert_for_metric_cpu_enabled              = true
alert_for_metric_iops_enabled             = true
alert_for_metric_vm_restarted_enabled     = true
alert_for_metric_vm_stopped_enabled       = true
alert_for_metric_disk_occupied_enabled    = true

# Backups
backup_policy_vm_enabled                  = true
backup_recovery_vault_resource_group_name = "SPWEPRGRSV001"
backup_recovery_vault_name                = "Backup"
backup_policy_vm_name                     = "DefaultPolicy"

# Optional
azurerm_virtual_network_bastion_vnet_name = "<network_name_to_create_bastion_subnetwork>"
azure_bastion_enabled                     = 0 // Set "1" to enable bastion creation
azurerm_subnets_internal_bastion_cidr     = ["10.1.3.224/27"]

# IAM
vm_iam_role_enabled             = false
vm_iam_role_object_id_enabled   = true // Enable when you specify a list of object ids of the users. Get ID: ```az ad user show --id <user>@telefonica.com | find "objectId"```
vm_iam_role_name                = "CustomRole_VirtualMachinePowerOnOff"
vm_iam_principal_id_list        = ["<email1_address>", ..., "<emailN_address>"]   // When "vm_iam_role_enabled" is true
vm_iam_principal_object_id_list = ["<object_id_user1>", "<object_id_userN>"] // When "vm_iam_role_object_id_enabled" is true

```
