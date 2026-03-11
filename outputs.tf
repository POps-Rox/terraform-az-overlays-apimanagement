# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############
# Outputs    ##
###############

output "apim_id" {
  value = azurerm_api_management.api_management.id
}

output "apim_name" {
  value = azurerm_api_management.api_management.name
}


