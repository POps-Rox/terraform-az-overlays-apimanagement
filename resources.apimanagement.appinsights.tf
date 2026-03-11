# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_application_insights" "apim_app_insights" {
  count               = var.enable_application_insights ? 1 : 0
  location            = local.location
  name                = local.apim_app_insights_name
  workspace_id        = var.log_analytics_workspace_id
  resource_group_name = local.resource_group_name
  application_type    = "web"
}

resource "azurerm_api_management_logger" "app_insights" {
  depends_on = [
    azurerm_api_management.api_management,
    azurerm_application_insights.apim_app_insights
  ]
  count               = var.enable_application_insights ? 1 : 0
  name                = local.apim_logger_name
  api_management_name = azurerm_api_management.api_management.name
  resource_group_name = local.resource_group_name

  application_insights {
    instrumentation_key = azurerm_application_insights.apim_app_insights[0].instrumentation_key
  }
}

resource "azurerm_api_management_diagnostic" "app_insights" {
  depends_on = [
    azurerm_api_management_logger.app_insights
  ]
  count                    = var.enable_application_insights ? 1 : 0
  identifier               = "applicationinsights"
  resource_group_name      = local.resource_group_name
  api_management_name      = azurerm_api_management.api_management.name
  api_management_logger_id = azurerm_api_management_logger.app_insights[0].id

  sampling_percentage       = 5.0
  always_log_errors         = true
  log_client_ip             = true
  verbosity                 = "verbose"
  http_correlation_protocol = "W3C"

  frontend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  frontend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }

  backend_request {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "accept",
      "origin",
    ]
  }

  backend_response {
    body_bytes = 32
    headers_to_log = [
      "content-type",
      "content-length",
      "origin",
    ]
  }
}