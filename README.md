# terraform-azure-service-health-notifications
This repository can be used to configure Service Health alerts across subscriptions in Azure to a specified e-mail address using Terraform.

```bash
terraform apply -var email_address=enter_email
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| azurerm | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| email\_address | (Required) The e-mail address or Distribution List that alerts should be sent to. | `string` | n/a | yes |
| subscriptions\_list | Used to define the list of subscriptions, each subscription must be in the format /subscriptions/xxxxx. If this is left blank it will just create a service health alert for the current subscriptions context. | `list` | /subscriptions/current_context | no |
| resource\_group\_name | Defines the name of the Resource Group that the alert configuration will reside (not the scope). | `string` | service_health_rg | no |
| resource\_group\_location | The location of the Resource Group that the alert configuration will reside. | `string` | East US 2 | no |