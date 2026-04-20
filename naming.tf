# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#------------------------------------------------------------
# Azure NoOps Naming - This should be used on all resource naming
#------------------------------------------------------------
data "popsrox_resource_name" "apim" {
  name          = var.workload_name
  resource_type = "azurerm_api_management"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix])
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "pip_name" {
  name          = var.workload_name
  resource_type = "azurerm_public_ip"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix])
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "nsg" {
  name          = var.workload_name
  resource_type = "azurerm_network_security_group"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix])
  clean_input   = true
  separator     = "-"
}

data "popsrox_resource_name" "identity" {
  name          = var.workload_name
  resource_type = "azurerm_user_assigned_identity"
  prefixes      = [var.org_name, var.use_location_short_name ? module.mod_azregions.location_short : var.location]
  suffixes      = compact([var.name_prefix == "" ? null : local.name_prefix, var.deploy_environment, local.name_suffix])
  clean_input   = true
  separator     = "-"
}
