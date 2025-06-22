# This Terraform configuration creates a Compute Instance in Azure Machine Learning Services.
resource "azurerm_user_assigned_identity" "msi" {
  location            = var.location
  name                = "azml-compute-msi"
  resource_group_name = module.naming.resource_group.name
}

#add rbac role assinments for storage account 
/*
resource "azurerm_role_assignment" "rbac_sa" {
  scope                = module.resource_group.resource_id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = azurerm_user_assigned_identity.msi.client_id
  depends_on          = [azurerm_user_assigned_identity.msi]
}
*/

resource "azapi_resource" "computeinstance" {
  count = var.create_compute_instance ? 1 : 0

  type = "Microsoft.MachineLearningServices/workspaces/computes@2024-10-01-preview"
  body = {
    properties = {
      computeLocation  = var.location
      computeType      = "ComputeInstance"
      disableLocalAuth = true
      properties = {
        enableNodePublicIp = false
        vmSize             = "Standard_E4ds_v4"
        schedules = {
            computeStartStop = [
            {
            action      = "Stop"
            triggerType = "Recurrence"
            status      = "Enabled"
            recurrence = {
                frequency = "Day"
                interval  = 1
                timeZone  = "Singapore Standard Time"
                schedule  = {
                hours     = [18]
                minutes   = [0]
                weekDays  = []
                monthDays = []
                }
                startTime = "2025-06-21T00:00:00"
                    }
                }
            ]
         }
      }
    }
  }
  location               = var.location
  name                   = "ci-${var.ci_name}"
  parent_id              = module.avm-res-machinelearningservices-workspace.resource_id
  response_export_values = ["*"]

  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.msi.id]
  }
}