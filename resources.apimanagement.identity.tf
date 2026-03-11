# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_user_assigned_identity" "apim_identity" {
  location            = local.location
  name                = local.apim_user_assigned_identity_name
  resource_group_name = local.resource_group_name
}

data "azurerm_user_assigned_identity" "apim_identity" {
  depends_on = [
    azurerm_user_assigned_identity.apim_identity
  ]
  name                = local.apim_user_assigned_identity_name
  resource_group_name = local.resource_group_name
}
