# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
# API Management Configuration     ##
#####################################

variable "enable_redis_cache" {
  description = "Controls if the redis cache should be enabled. Default is true."
  type        = bool
  default     = true
}

variable "apim_custom_name" {
  description = "Custom name for the API Management instance. If not set, the name will be generated using the `org_name`, `workload_name`, `deploy_environment` and `environment` variables."
  type        = string
  default     = null
}

variable "sku_tier" {
  description = "The tier of the API Management instance. Possible values are Developer, Basic, Standard, Premium, Consumption."
  type        = string
  default     = "Developer"
}
variable "sku_capacity" {
  description = "The capacity of the API Management instance. Possible values are positive integers from 1-12, except for Consumption tier where it is 0."
  type        = number
  default     = 1
}

variable "publisher_email" {
  description = "The email address of the publisher."
  type        = string
}
variable "publisher_name" {
  description = "The name of the publisher."
  type        = string
}

variable "enable_user_identity" {
  description = "Controls if the user identity should be enabled."
  type        = bool
  default     = true
}

variable "min_api_version" {
  description = "The minimum supported API version for the API Management Management API."
  type        = string
  default     = "2022-08-01"
}

#####################################
# Networking Configuration         ## 
#####################################
variable "apim_subnet_name" {
  description = "Name of the subnet for the API Management"
  type        = string
}


