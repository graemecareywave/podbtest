provider "google" {
  # Resource google_monitoring_dashboard is available since 3.23.0
  # https://github.com/terraform-providers/terraform-provider-google/releases/tag/3.23
  project = "starry-diode-376414"
  region  = "us-central1"
}

terraform {
  required_providers {
    google = {
      version = "~> 3.83.0"
    }
  }
}

# resource "google_logging_metric" "internal_error_metric" {
#   name        = var.metric_name
#   project     = var.project_id
#   description = "Count of logs with internal server error from compute engine."
#   filter      = "resource.type=gce_instance AND logName:\"projects/[PROJECT_ID]/logs/compute.googleapis.com%2Fsystem_event\" AND textPayload:\"*Status: 500 Response:nb'Internal Server Error\\n'\""
#   metric_descriptor {
#     metric_kind = "DELTA"
#     value_type  = "INT64"
#     /*
#       labels {
#       key         = "log"
#       value_type  = "STRING"
#       description = "The log from which the metric was obtained."
#     }
#     */
#   }
# }

resource "google_logging_metric" "internal_error_metric2" {
  name        = var.metric_name
  project     = var.project_id
  description = "Count of logs with internal server error from compute engine."
  # Original filter
  # filter      = "resource.type=gce_instance AND logName:\"projects/[PROJECT_ID]/logs/compute.googleapis.com%2Fsystem_event\" AND textPayload:\"404\""
  filter = "resource.type=\"k8s_container\" AND log_name=\"projects/starry-diode-376414/logs/stdout\" AND textPayload: \"404\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    /*
      labels {
      key         = "log"
      value_type  = "STRING"
      description = "The log from which the metric was obtained."
    }
    */
  }
}

resource "google_monitoring_alert_policy" "internal_error_alert2" {
  project      = var.project_id
  display_name = var.alert_policy_name
  combiner     = "OR"

  conditions {
    display_name = "compute_engine_internal_error_condition"
    condition_threshold {
      filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.internal_error_metric2.name}\" AND resource.type=\"k8s_container\""
      duration        = "60s"
      comparison      = "COMPARISON_GT"
      threshold_value = 0.01

      trigger {
        count = 1
      }

      aggregations {
        alignment_period     = "600s"
        per_series_aligner   = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields      = ["resource.labels.instance_id"]
      }
    }
  }

  notification_channels = var.alert_channels
}

# resource "google_monitoring_alert_policy" "internal_error_alert" {
#   project      = var.project_id
#   display_name = var.alert_policy_name
#   combiner     = "OR"

#   conditions {
#     display_name = "compute_engine_internal_error_condition"
#     condition_threshold {
#       filter          = "metric.type=\"logging.googleapis.com/user/${google_logging_metric.internal_error_metric.name}\" AND resource.type=\"gce_instance\""
#       duration        = "300s"
#       comparison      = "COMPARISON_GT"
#       threshold_value = 1.0

#       trigger {
#         count = 1
#       }

#       aggregations {
#         alignment_period     = "600s"
#         per_series_aligner   = "ALIGN_RATE"
#         cross_series_reducer = "REDUCE_SUM"
#         group_by_fields      = ["resource.labels.instance_id"]
#       }
#     }
#   }

#   notification_channels = var.alert_channels
# }
