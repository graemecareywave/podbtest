resource "google_monitoring_alert_policy" "internal_error_alert" {
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

resource "google_monitoring_alert_policy" "internal_error_alert" {
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