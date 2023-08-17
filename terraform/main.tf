resource "google_logging_project_metric" "internal_error_metric" {
  name        = var.metric_name
  project     = var.project_id
  description = "Count of logs with internal server error from compute engine."
  filter      = "resource.type=gce_instance AND logName:\"projects/[PROJECT_ID]/logs/compute.googleapis.com%2Fsystem_event\" AND textPayload:\"*Status: 500 Response:nb'Internal Server Error\\n'\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
    labels {
      key         = "log"
      value_type  = "STRING"
      description = "The log from which the metric was obtained."
    }
  }
}

resource "google_monitoring_alert_policy" "internal_error_alert" {
  project      = var.project_id
  display_name = var.alert_policy_name
  combiner     = "OR"

  conditions {
    display_name = "compute_engine_internal_error_condition"
    condition_threshold {
      filter     = "metric.type=\"logging.googleapis.com/user/${google_logging_project_metric.internal_error_metric.name}\""
      duration   = "300s"
      comparison = "COMPARISON_GT"
      threshold_value = 1.0

      trigger {
        count = 1
      }

      aggregations {
        alignment_period   = "600s"
        per_series_aligner = "ALIGN_RATE"
        cross_series_reducer = "REDUCE_SUM"
        group_by_fields     = ["instance_id"]
      }
    }
  }

  notification_channels = var.alert_channels
}
Variables.tf

variable "project_id" {
  description = "The project ID to deploy to"
}

variable "metric_name" {
  description = "Name of the log-based metric."
  default     = "compute_engine_internal_error_metric"
}

variable "alert_policy_name" {
  description = "The display name for the alert policy."
  default     = "Compute Engine Internal Error Alert"
}

variable "alert_channels" {
  description = "List of notification channels in which the alert will be delivered"
  type        = list(string)
}