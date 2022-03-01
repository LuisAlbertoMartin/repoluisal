# IAM assignments
locals {
  pair           = var.vm_iam_role_enabled ? setproduct(azurerm_linux_virtual_machine.vm.*.id, data.azuread_users.users.*.object_ids) : null
  pair_object_id = var.vm_iam_role_object_id_enabled ? setproduct(azurerm_linux_virtual_machine.vm.*.id, var.vm_iam_principal_object_id_list) : null
}

# Assign role according the users email
resource "azurerm_role_assignment" "vm" {
  count                = var.vm_iam_role_enabled ? length(local.pair) : 0
  description          = "Iam role assignment to virtual machine"
  scope                = element(local.pair[count.index], 0)
  role_definition_name = var.vm_iam_role_name
  principal_id         = element(local.pair[count.index][1], 0)
}

# Assign role according the object_id attribute of the users
resource "azurerm_role_assignment" "vm-object-id" {
  count                = var.vm_iam_role_enabled == false && var.vm_iam_role_object_id_enabled ? length(local.pair_object_id) : 0
  description          = "Iam role assignment to virtual machine"
  scope                = element(local.pair_object_id[count.index], 0)
  role_definition_name = var.vm_iam_role_name
  principal_id         = element(local.pair_object_id[count.index], 1)
}
