# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id = "00000000-0000-0000-0000-000000000001"
    }
  }

  mock_data "azurerm_resource_group" {
    defaults = {
      name     = "rg-existing"
      location = "eastus"
    }
  }

  mock_data "azurerm_subnet" {
    defaults = {
      id                   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/virtualNetworks/vnet-apim/subnets/snet-apim"
      name                 = "snet-apim"
      virtual_network_name = "vnet-apim"
    }
  }

  mock_data "azurerm_virtual_network" {
    defaults = {
      name = "vnet-apim"
    }
  }

  mock_data "azurerm_user_assigned_identity" {
    defaults = {
      id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-apim"
      principal_id = "00000000-0000-0000-0000-000000000002"
    }
  }

  mock_data "azurerm_network_security_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/networkSecurityGroups/nsg-apim"
    }
  }

  mock_resource "azurerm_api_management" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.ApiManagement/service/apim-custom"
    }
  }

  mock_resource "azurerm_user_assigned_identity" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.ManagedIdentity/userAssignedIdentities/id-apim"
    }
  }

  mock_resource "azurerm_network_security_group" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/networkSecurityGroups/nsg-apim"
    }
  }

  mock_resource "azurerm_public_ip" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Network/publicIPAddresses/pip-apim"
    }
  }

  mock_resource "azurerm_application_insights" {
    defaults = {
      instrumentation_key = "00000000-0000-0000-0000-000000000003"
    }
  }
}

mock_provider "popsrox" {
  mock_data "popsrox_resource_name" {
    defaults = {
      result = "generated-name"
    }
  }
}

override_module {
  target = module.mod_azregions
  outputs = {
    location_cli   = "eastus"
    location_short = "eus"
  }
}

override_module {
  target = module.mod_scaffold_rg
  outputs = {
    resource_group_name     = "rg-created"
    resource_group_location = "eastus"
  }
}

override_module {
  target = module.mod_redis_cache
  outputs = {
    redis_name                      = "redis-apim"
    redis_id                        = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.Cache/Redis/redis-apim"
    redis_primary_connection_string = "mock-redis-connection-string"
  }
}

override_module {
  target = module.mod_key_vault
  outputs = {
    key_vault_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-existing/providers/Microsoft.KeyVault/vaults/kv-apim"
  }
}

variables {
  location                     = "eastus"
  environment                  = "public"
  deploy_environment           = "dev"
  workload_name                = "apim"
  org_name                     = "anoa"
  existing_resource_group_name = "rg-existing"
  publisher_email              = "apim_admins@example.com"
  publisher_name               = "apim"
  virtual_network_name         = "vnet-apim"
  apim_subnet_name             = "snet-apim"
  existing_private_subnet_name = "snet-private"
  enable_resource_locks        = false
  create_apim_keyvault         = false
  enable_redis_cache           = false
  enable_application_insights  = false
}

run "consumer_contract_defaults_and_disabled_optionals" {
  command = plan

  assert {
    condition     = azurerm_api_management.api_management.name == "generated-name"
    error_message = "APIM should use the generated name when apim_custom_name is null."
  }

  assert {
    condition     = azurerm_api_management.api_management.location == "eastus"
    error_message = "APIM location should pass through the resource group location."
  }

  assert {
    condition     = azurerm_api_management.api_management.sku_name == "Developer_1"
    error_message = "APIM SKU should combine sku_tier and sku_capacity for non-Consumption tiers."
  }

  assert {
    condition     = length(module.mod_redis_cache) == 0 && length(azurerm_api_management_redis_cache.api_management_redis_cache) == 0
    error_message = "Redis module and APIM Redis cache should be omitted when enable_redis_cache is false."
  }

  assert {
    condition     = length(module.mod_key_vault) == 0 && length(azurerm_key_vault_access_policy.apim_access_policy) == 0
    error_message = "Key Vault module and access policy should be omitted when create_apim_keyvault is false."
  }

  assert {
    condition     = length(azurerm_application_insights.apim_app_insights) == 0 && length(azurerm_api_management_logger.app_insights) == 0 && length(azurerm_api_management_diagnostic.app_insights) == 0
    error_message = "Application Insights resources should be omitted when enable_application_insights is false."
  }

  assert {
    condition     = length(azurerm_management_lock.apim_lock) == 0 && length(azurerm_management_lock.apim_identity_lock) == 0 && length(azurerm_management_lock.apim_nsg_level_lock) == 0 && length(azurerm_management_lock.apim_pip_level_lock) == 0 && length(azurerm_management_lock.apim_level_lock) == 0
    error_message = "Management locks should be omitted when enable_resource_locks is false."
  }
}

run "custom_overrides_and_enabled_optionals" {
  command = plan

  variables {
    apim_custom_name            = "apim-custom"
    sku_tier                    = "Premium"
    sku_capacity                = 2
    create_apim_keyvault        = true
    enable_redis_cache          = true
    enable_application_insights = true
    enable_resource_locks       = true
    add_tags = {
      owner = "platform"
      env   = "override"
    }
  }

  assert {
    condition     = azurerm_api_management.api_management.name == "apim-custom"
    error_message = "apim_custom_name should take precedence over generated naming."
  }

  assert {
    condition     = azurerm_api_management.api_management.sku_name == "Premium_2"
    error_message = "APIM SKU should use the requested Premium capacity."
  }

  assert {
    condition     = length(module.mod_redis_cache) == 1 && length(azurerm_api_management_redis_cache.api_management_redis_cache) == 1
    error_message = "Redis module and APIM Redis cache should be created when enable_redis_cache is true."
  }

  assert {
    condition     = length(module.mod_key_vault) == 1 && length(azurerm_key_vault_access_policy.apim_access_policy) == 1
    error_message = "Key Vault module and access policy should be created when create_apim_keyvault is true."
  }

  assert {
    condition     = length(azurerm_application_insights.apim_app_insights) == 1 && length(azurerm_api_management_logger.app_insights) == 1 && length(azurerm_api_management_diagnostic.app_insights) == 1
    error_message = "Application Insights resources should be created when enable_application_insights is true."
  }

  assert {
    condition     = length(azurerm_management_lock.apim_lock) == 1 && length(azurerm_management_lock.apim_identity_lock) == 1 && length(azurerm_management_lock.apim_nsg_level_lock) == 1 && length(azurerm_management_lock.apim_pip_level_lock) == 1 && length(azurerm_management_lock.apim_level_lock) == 1
    error_message = "All public-environment management locks should be created when enable_resource_locks is true."
  }

  assert {
    condition     = azurerm_api_management.api_management.tags.owner == "platform" && azurerm_api_management.api_management.tags.env == "dev" && azurerm_api_management.api_management.tags.workload == "apim"
    error_message = "APIM tags should merge caller tags with module default tags, with default tags taking precedence."
  }
}

run "empty_string_custom_name_falls_through_to_generated_name" {
  command = plan

  variables {
    apim_custom_name = ""
  }

  assert {
    condition     = azurerm_api_management.api_management.name == "generated-name"
    error_message = "An empty apim_custom_name should fall through to generated naming."
  }
}

run "consumption_sku_branch" {
  command = plan

  variables {
    sku_tier     = "Consumption"
    sku_capacity = 5
  }

  assert {
    condition     = azurerm_api_management.api_management.sku_name == "Consumption_0"
    error_message = "Consumption SKU should always map to Consumption_0 regardless of sku_capacity."
  }
}

run "government_environment_omits_public_ip_and_lock" {
  command = plan

  variables {
    environment           = "usgovernment"
    enable_resource_locks = true
  }

  assert {
    condition     = length(azurerm_public_ip.apim_pip) == 0 && azurerm_api_management.api_management.public_ip_address_id == null && length(azurerm_management_lock.apim_pip_level_lock) == 0
    error_message = "Non-public environments should not create or attach a public IP or public IP lock."
  }
}
