# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

moved {
  from = azurerm_key_vault_access_policy.apim_access_policy
  to   = azurerm_key_vault_access_policy.apim_access_policy[0]
}
