terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
    }
  }
}

data "azurerm_client_config" "current" {}

provider "azurerm" {
  features {
    
  }
}

variable email_address {
    description = "(Required) The e-mail address or Distribution List that alerts should be sent to."
}

variable "subscriptions_list" {
  default = []
  type = list
  description = "Used to define the list of subscriptions, each subscription must be in the format /subscriptions/xxxxx. If this is left blank it will just create a service health alert for the current subscriptions context."
}

variable "resource_group_name" {
  default = "service_health_rg"
  description = "Defines the name of the Resource Group that the alert configuration will reside (not the scope). If left blank the default will be service_health_rg"
}

variable "resource_group_location" {
  default = "East US2"
  description = "The location of the Resource Group that the alert configuration will reside. If left blank the default will be East US 2"
}

locals {
    email_address = var.email_address
    subscriptions_list = length(var.subscriptions_list) == 0 ? ["/subscriptions/${data.azurerm_client_config.current.subscription_id}"] : var.subscriptions_list
    resource_group_name = var.resource_group_name
    resource_group_location = var.resource_group_location

}

locals {
    common_tags =  {
      environment = "Production"
    }
}
  
//location of the action group metadata configuration
resource "azurerm_resource_group" "service_health_rg" {
  name     = local.resource_group_name
  location = local.resource_group_location

  tags = local.common_tags 
}

resource "azurerm_monitor_action_group" "service_health_action_group" {
  name                = "service_health_ag"
  resource_group_name = azurerm_resource_group.service_health_rg.name
  short_name          = "shalert"

  email_receiver {
    name          = "SendToAlertDL"
    email_address = local.email_address
  }

  tags = local.common_tags 
}

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "service_health_ag"
  resource_group_name = azurerm_resource_group.service_health_rg.name
  scopes              = local.subscriptions_list
  description         = "This alert will monitor a specific storage account updates."

  criteria {
    category = "ServiceHealth"
  }

  action {
    action_group_id = azurerm_monitor_action_group.service_health_action_group.id
  }

  tags = local.common_tags 
}