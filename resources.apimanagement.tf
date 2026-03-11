# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_public_ip" "apim_pip" {
  # To deploy APIM to the stv2 platform, you must specify a public IP address else it will deploy to stv1. 
  # The stv2 platform currently is not supported in Azure USGovernment.  Remove this check when stv2 is supported in Azure US Government. 
  count               = var.environment == "public" ? 1 : 0
  name                = local.apim_pip_name
  resource_group_name = local.resource_group_name
  location            = local.location
  allocation_method   = "Static"
  sku                 = "Standard"
  domain_name_label   = lower(local.apim_pip_name)
  tags                = merge(var.add_tags, local.default_tags)
}

resource "azurerm_api_management" "api_management" {
  depends_on = [
    azurerm_user_assigned_identity.apim_identity,
    azurerm_public_ip.apim_pip,
    azurerm_subnet_network_security_group_association.apim-subnet-nsg-association
  ]
  timeouts {
    create = "240m"
    update = "120m"
    delete = "60m"
  }

  name                = local.apim_name
  location            = local.location
  resource_group_name = local.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email

  min_api_version      = var.min_api_version
  public_ip_address_id = var.environment == "public" ? azurerm_public_ip.apim_pip[0].id : null
  sku_name             = local.sku_name
  virtual_network_type = "Internal" # This is used for SCCA compliance

  virtual_network_configuration {
    subnet_id = data.azurerm_subnet.apim_subnet.id
  }

  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.apim_identity.id
    ]
  }

  tags = merge(var.add_tags, local.default_tags)
}

resource "azurerm_api_management_redis_cache" "api_management_redis_cache" {
  depends_on = [
    azurerm_api_management.api_management,
    module.mod_redis_cache
  ]
  count             = var.enable_redis_cache ? 1 : 0
  name              = lower(module.mod_redis_cache.0.redis_name)
  api_management_id = azurerm_api_management.api_management.id
  connection_string = module.mod_redis_cache.0.redis_primary_connection_string
  description       = "Redis cache instances"
  redis_cache_id    = module.mod_redis_cache.0.redis_id
  cache_location    = local.location
}
