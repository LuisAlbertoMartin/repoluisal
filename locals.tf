locals {
  # ID of the resource group
  resource_group_id = format("/subscriptions/%s/resourceGroups/%s", var.subscription_id, var.resource_group_name)
}

