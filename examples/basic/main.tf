# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_apim" {
  depends_on = [
    azurerm_resource_group.apim_rg,
    azurerm_virtual_network.apim_vnet,
    azurerm_subnet.apim_subnet,
    azurerm_subnet.pe_subnet
  ]
  source = "../.."
  #source  = "azurenoops/overlays-api-management/azurerm"
  #version = ">= 1.0.0"

  # By default, this module will create a resource group and 
  # provide a name for an existing resource group. If you wish 
  # to use an existing resource group, change the option 
  # to "create_maps_resource_group = false." The location of the group 
  # will remain the same if you use the current resource.
  existing_resource_group_name = azurerm_resource_group.apim_rg.name
  location                     = module.mod_azure_region_lookup.location_cli
  environment                  = "public"
  deploy_environment           = "dev"
  org_name                     = "anoa"
  workload_name                = "apim"

  # API Management configuration
  enable_user_identity = true
  publisher_email      = "apim_admins@microsoft.com"
  publisher_name       = "apim"
  min_api_version      = "2019-12-01"

  # SKU configuration
  sku_tier     = "Developer"
  sku_capacity = 1

  # Virtual network configuration
  virtual_network_name = azurerm_virtual_network.apim_vnet.name
  apim_subnet_name     = azurerm_subnet.apim_subnet.name # This is the subnet where APIM will be deployed. 

  # Private endpoint configuration
  # Key Vault and Redis are deployed by default.
  # So we need to make sure that the subnet is configured for private endpoints.
  existing_private_subnet_name = azurerm_subnet.pe_subnet.name

  # This is to enable resource locks for the key vault. 
  enable_resource_locks = false

  # Tags
  add_tags = local.tags # Tags to be applied to all resources
}
