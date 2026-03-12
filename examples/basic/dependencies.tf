# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#---------------------------------------------------------
# Azure Region Lookup
#----------------------------------------------------------
module "mod_azure_region_lookup" {
  source = "github.com/POps-Rox/tf-az-overlays-azregionslookup"

  azure_region = "eastus"
}

resource "azurerm_resource_group" "apim_rg" {
  name     = "rg-apim"
  location = module.mod_azure_region_lookup.location_cli
}

resource "azurerm_virtual_network" "apim_vnet" {
  name                = "vnet-apim"
  location            = module.mod_azure_region_lookup.location_cli
  resource_group_name = azurerm_resource_group.apim_rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "apim_subnet" {
  name                 = "snet-apim"
  resource_group_name  = azurerm_resource_group.apim_rg.name
  virtual_network_name = azurerm_virtual_network.apim_vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "pe_subnet" {
  name                 = "pe-snet-apim"
  resource_group_name  = azurerm_resource_group.apim_rg.name
  virtual_network_name = azurerm_virtual_network.apim_vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}
