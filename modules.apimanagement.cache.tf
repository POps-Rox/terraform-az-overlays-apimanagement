# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_redis_cache" {
  depends_on = [
    module.mod_scaffold_rg,
  ]
  source                       = "github.com/POps-Rox/tf-az-overlays-redis"
  version                      = "~> 2.0"
  count                        = var.enable_redis_cache ? 1 : 0
  location                     = lower(local.location)
  org_name                     = lower(var.org_name)
  environment                  = lower(var.environment)
  workload_name                = lower(var.workload_name)
  existing_resource_group_name = local.resource_group_name

  # Creating Private Endpoint requires, VNet name to create a Private Endpoint
  # By default this will create a `privatelink.redis.cache.windows.net` DNS zone. if created in commercial cloud
  # To use existing subnet, specify `existing_private_subnet_name` with valid subnet name. 
  # To use existing private DNS zone specify `existing_redis_private_dns_zone` with valid zone name.
  enable_private_endpoint      = var.enable_redis_cache
  existing_private_subnet_name = var.existing_private_subnet_name != null ? data.azurerm_subnet.snet.0.name : null
  existing_private_dns_zone    = var.existing_redis_private_dns_zone != null ? var.existing_redis_private_dns_zone : null
  virtual_network_name         = var.virtual_network_name != null ? var.virtual_network_name : null

  // Tags
  add_tags = merge(var.add_tags, local.default_tags) # Tags to be applied to all resources
}

