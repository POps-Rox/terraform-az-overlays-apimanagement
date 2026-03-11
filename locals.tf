# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

# remove file if not needed

locals {
  sku_name = var.sku_tier == "Consumption" ? "Consumption_0" : format("%s%s%s", var.sku_tier, "_", var.sku_capacity)
}