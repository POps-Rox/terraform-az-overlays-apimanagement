<!-- BADGES:START -->
[![CI](https://github.com/POps-Rox/tf-az-overlays-apimanagement/actions/workflows/ci.yml/badge.svg)](https://github.com/POps-Rox/tf-az-overlays-apimanagement/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](https://github.com/POps-Rox/tf-az-overlays-apimanagement/pulls)
[![Maintained](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/POps-Rox/tf-az-overlays-apimanagement/graphs/commit-activity)
[![Terraform](https://img.shields.io/badge/Terraform-%3E%3D1.5-623CE4.svg?logo=terraform)](https://www.terraform.io)
<!-- BADGES:END -->

# Azure NoOps API Management Overlay Module

[![Changelog](https://img.shields.io/badge/changelog-release-green.svg)](CHANGELOG.md) [![Notice](https://img.shields.io/badge/notice-copyright-yellow.svg)](NOTICE) [![MIT License](https://img.shields.io/badge/license-MIT-orange.svg)](LICENSE) [![TF Registry](https://img.shields.io/badge/terraform-registry-blue.svg)](https://registry.terraform.io/modules/POps-Rox/overlays-api-management/azurerm/)

This Overlay terraform module can create a API Management resource and manage related parameters (Storage, Key Vault, Redis Cache, NSG Rules, Private Endpoints, etc.) to be used in a [SCCA compliant Network](https://registry.terraform.io/modules/POps-Rox/overlays-management-hub/azurerm/latest).

## SCCA Compliance

This module can be SCCA compliant and can be used in a SCCA compliant Network. Enable private endpoints and SCCA compliant network rules to make it SCCA compliant.

For more information, please read the [SCCA documentation]("https://www.cisa.gov/secure-cloud-computing-architecture").

## Contributing

If you want to contribute to this repository, feel free to to contribute to our Terraform module.

More details are available in the [CONTRIBUTING.md](./CONTRIBUTING.md#pull-request-process) file.

## Resources Used

* [API Management](https://www.terraform.io/docs/providers/azurerm/r/api_management.html)
* [Redis Cache](https://www.terraform.io/docs/providers/azurerm/r/redis_cache.html)
* [Storage Account](https://www.terraform.io/docs/providers/azurerm/r/storage_account.html)
* [Key Vault](https://www.terraform.io/docs/providers/azurerm/r/key_vault.html)
* [Private Endpoints](https://www.terraform.io/docs/providers/azurerm/r/private_endpoint.html)
* [Private DNS zone for `privatelink` A records](https://www.terraform.io/docs/providers/azurerm/r/private_dns_zone.html)
* [Azure Reource Locks](https://www.terraform.io/docs/providers/azurerm/r/management_lock.html)

## Overlay Module Usage

<!-- BEGIN_TF_DOCS -->
## Requirements

```hcl
# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "mod_apim" {
  depends_on = [
    azurerm_resource_group.apim_rg,
    azurerm_virtual_network.apim_vnet,
    azurerm_subnet.apim_subnet,
    azurerm_subnet.pe_subnet
  ]
  source  = "POps-Rox/tf-az-overlays-api-management/azurerm"
  version = "~> X.X"

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
  publisher_email = "apim_admins@microsoft.com"
  publisher_name  = "apim"  
  min_api_version      = "2019-12-01"

  # SKU configuration
  sku_tier             = "Developer"
  sku_capacity         = 1

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
```

## Providers

| Name | Version |
|------|---------|
| popsrox-utils | ~> 1.0.4 |
| azurerm | ~> 3.116 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| mod\_azregions | POps-Rox/overlays-azregions-lookup/azurerm | ~> 1.0.0 |
| mod\_key\_vault | POps-Rox/overlays-key-vault/azurerm | ~> 2.0 |
| mod\_redis\_cache | POps-Rox/overlays-redis/azurerm | ~> 2.0 |
| mod\_scaffold\_rg | POps-Rox/overlays-resource-group/azurerm | ~> 1.0.1 |
## Resources

| Name | Type |
|------|------|
| [azurerm_api_management.api_management](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management) | resource |
| [azurerm_api_management_diagnostic.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_diagnostic) | resource |
| [azurerm_api_management_logger.app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_logger) | resource |
| [azurerm_api_management_redis_cache.api_management_redis_cache](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/api_management_redis_cache) | resource |
| [azurerm_application_insights.apim_app_insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights) | resource |
| [azurerm_key_vault_access_policy.apim_access_policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_access_policy) | resource |
| [azurerm_management_lock.apim_dev_dns_zone_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.apim_identity_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.apim_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.apim_nsg_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_management_lock.apim_pip_level_lock](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_network_security_group.apim-nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_private_dns_a_record.a_rec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_a_record.apim_dev_portal_a_rec](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_a_record) | resource |
| [azurerm_private_dns_zone.apim_dev_portal_dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone.dns_zone](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone) | resource |
| [azurerm_private_dns_zone_virtual_network_link.apim_dev_portalvnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_dns_zone_virtual_network_link.vnet_link](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_dns_zone_virtual_network_link) | resource |
| [azurerm_private_endpoint.pep](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/private_endpoint) | resource |
| [azurerm_public_ip.apim_pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/public_ip) | resource |
| [azurerm_subnet_network_security_group_association.apim-subnet-nsg-association](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/subnet_network_security_group_association) | resource |
| [azurerm_user_assigned_identity.apim_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) | resource |
| [popsrox_utils_resource_name.apim](https://registry.terraform.io/providers/POps-Rox/popsrox-utils/latest/docs/data-sources/resource_name) | data source |
| [popsrox_utils_resource_name.keyvault](https://registry.terraform.io/providers/POps-Rox/popsrox-utils/latest/docs/data-sources/resource_name) | data source |
| [azurerm_api_management.apim](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/api_management) | data source |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_network_security_group.apim-nsg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/network_security_group) | data source |
| [azurerm_private_endpoint_connection.pip](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/private_endpoint_connection) | data source |
| [azurerm_resource_group.rgrp](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resource_group) | data source |
| [azurerm_subnet.apim_subnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_subnet.snet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subnet) | data source |
| [azurerm_user_assigned_identity.apim_identity](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) | data source |
| [azurerm_virtual_network.vnet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/virtual_network) | data source |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| add\_tags | Map of custom tags. | `map(string)` | `{}` | no |
| apim\_custom\_name | Custom name for the API Management instance. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| apim\_subnet\_name | Name of the subnet for the API Management | `string` | n/a | yes |
| create\_apim\_keyvault | Controls if the keyvault should be created. If set to false, the keyvault name must be provided. Default is false. | `bool` | `true` | no |
| create\_apim\_resource\_group | Controls if the resource group should be created. If set to false, the resource group name must be provided. Default is false. | `bool` | `false` | no |
| custom\_resource\_group\_name | The name of the custom resource group to create. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| default\_tags\_enabled | Option to enable or disable default tags. | `bool` | `true` | no |
| deploy\_environment | Name of the workload's environment | `string` | n/a | yes |
| enable\_application\_insights | Controls if the application insights should be created. Default is true. | `bool` | `true` | no |
| enable\_private\_endpoint | Manages a Private Endpoint to Azure API Management. Default is false. | `bool` | `false` | no |
| enable\_redis\_cache | Controls if the redis cache should be enabled. Default is true. | `bool` | `true` | no |
| enable\_resource\_locks | (Optional) Enable resource locks, default is false. If true, resource locks will be created for the resource group and the storage account. | `bool` | `false` | no |
| enable\_user\_identity | Controls if the user identity should be enabled. | `bool` | `true` | no |
| enabled\_for\_template\_deployment | Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault. | `bool` | `false` | no |
| environment | The Terraform backend environment e.g. public or usgovernment | `string` | n/a | yes |
| existing\_apim\_dev\_portal\_dns\_zone | The ID of an existing private dns zone to use. If not set, a new private dns zone will be created. | `string` | `null` | no |
| existing\_apim\_private\_dns\_zone | The ID of an existing private dns zone to use. If not set, a new private dns zone will be created. | `string` | `null` | no |
| existing\_keyvault\_private\_dns\_zone | The ID of an existing private dns zone to use for Key Vault. If not set, a new private dns zone will be created. | `string` | `null` | no |
| existing\_private\_dns\_zone | Name of the existing private DNS zone | `any` | `null` | no |
| existing\_private\_subnet\_name | Name of the existing private subnet for the private endpoint | `any` | `null` | no |
| existing\_redis\_private\_dns\_zone | The ID of an existing private dns zone to use for Redis. If not set, a new private dns zone will be created. | `string` | `null` | no |
| existing\_resource\_group\_name | The name of the existing resource group to use. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| existing\_vnet\_id | The ID of an existing virtual network to use. If not set, a new virtual network will be created. | `string` | `null` | no |
| key\_vault\_custom\_name | Custom name for the keyvault. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables. | `string` | `null` | no |
| key\_vault\_sku\_name | The SKU name of the Key Vault to create. Possible values are standard and premium. | `string` | `"standard"` | no |
| location | Azure region in which instance will be hosted | `string` | n/a | yes |
| lock\_level | (Optional) id locks are enabled, Specifies the Level to be used for this Lock. | `string` | `"CanNotDelete"` | no |
| log\_analytics\_workspace\_id | The ID of the Log Analytics Workspace to use for Application Insights. | `string` | `null` | no |
| min\_api\_version | The minimum supported API version for the API Management Management API. | `string` | `"2022-08-01"` | no |
| name\_prefix | Optional prefix for the generated name | `string` | `""` | no |
| name\_suffix | Optional suffix for the generated name | `string` | `""` | no |
| org\_name | Name of the organization | `string` | n/a | yes |
| publisher\_email | The email address of the publisher. | `string` | n/a | yes |
| publisher\_name | The name of the publisher. | `string` | n/a | yes |
| purge\_protection\_enabled | Specifies whether protection against purge is enabled for this key vault. Default is true. | `bool` | `true` | no |
| sku\_capacity | The capacity of the API Management instance. Possible values are positive integers from 1-12, except for Consumption tier where it is 0. | `number` | `1` | no |
| sku\_tier | The tier of the API Management instance. Possible values are Developer, Basic, Standard, Premium, Consumption. | `string` | `"Developer"` | no |
| use\_location\_short\_name | Use short location name for resources naming (ie eastus -> eus). Default is true. If set to false, the full cli location name will be used. if custom naming is set, this variable will be ignored. | `bool` | `true` | no |
| use\_naming | Use the Azure NoOps naming provider to generate default resource name. `storage_account_custom_name` override this if set. Legacy default name is used if this is set to `false`. | `bool` | `true` | no |
| virtual\_network\_name | Name of the virtual network for the private endpoint | `any` | `null` | no |
| workload\_name | Name of the workload\_name | `string` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| apim\_id | n/a |
| apim\_name | n/a |
<!-- END_TF_DOCS -->