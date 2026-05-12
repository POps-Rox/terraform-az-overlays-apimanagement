# Changelog

# v2.0.0 - Phase 1 azurerm 4.x upgrade

Changed (BREAKING)
- Raised `required_version` from `>= 1.9` to `>= 1.10`
- Raised `azurerm` provider constraint from `~> 3.116` to `~> 4.20`
- Added `azapi ~> 2.0` to `required_providers` for fleet alignment
- All `examples/**/versions.tf` files updated with matching constraints

Audited (no code change required)
- No `enable_https_traffic_only` / `allow_blob_public_access` /
  `enable_rbac_authorization` usage in this module.
- No `private_endpoint_network_policies_enabled` subnet attribute (no subnet
  resources declared here).
- No `azurerm_monitor_diagnostic_setting` resources, so no `retention_policy`
  block removals required.
- No standalone `azurerm_api_management_policy` /
  `azurerm_api_management_api_policy` / `azurerm_api_management_product_policy`
  resources declared, and no inline `policy { … }` blocks. The 4.x `policy`
  schema tightening (xml_content / xml_link become mutually exclusive scalars)
  is therefore N/A for this overlay.

Consumer-facing notes
- `azurerm` 4.x requires an explicit subscription (`ARM_SUBSCRIPTION_ID` env
  var or `subscription_id` in `provider "azurerm"`).

# v1.0.0 - <date>
