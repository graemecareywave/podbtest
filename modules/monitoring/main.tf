//----------------Notification Channels------------------------

locals {
    notification_email_address = trimspace(coalesce(var.notification_email_address, " "))
    notification_email_enabled = local.notification_email_address != ""

    notification_channels = flatten([
        local.notification_email_enabled ? [google_monitoiring_notification_channel.email[0].id] : []
    ])
}

resource "google_monitoring_notification_channel" "email" {
    count = local.notification_email_enabled ? 1 : 0
    display_name = "Email Notification Channel"
    project = var.project_id
    type = "email"
    labels = {
      email_address = local.notification_email_address // "user@company"
    }
    # force_delete = false  
}

data "google_montioring_notification_channel" "netcool_email" {
    display_name = "Netcool"
}

//----------------------Alert Policies-----------------------------
resource "google_monitoring_alert" "MSP Apigee MIG Alert Policy" {
    for_each = var.instance_groups !=null ? var.instance_groups : {}
    # count = local.notification_email_enabled && var.instance_group_name != null ? 1 : 0
    project = var.project_id
    display_name = "msp-apigee-mig-instance-unhealthy" 
    combiner = "OR"
    conditions {
        display_name = "MSP Apigee MIG Unhealthy"
        condition_matched_log {
            filter = "resource.type=\"gce_instance_group\"\nresource.lables.instance_group_name=\"${each.key}\"\njsonPayload.healthCheckProbeResult.healthState=\"UNHEALTHY\""
        }
    }
  users_labels = {
    gcp_service = "apigee"
    assignment_group = "cloud_operations"
  }

  documentation {
    content = "MSP to review MIG, LB, and Backend Services"
  }

  alert_strategy {
    auto_close = "86400"
    notification_rate_limit =
      {
        period = "1800s"
      }
  }

  notification_channels = [data.google_monitoiring_notification_channel.netcool_email.name]
    display_name = "Netcool"
  # notification_channels = local.notification_channels
}