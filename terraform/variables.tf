variable "project_id" {
  description = "The project ID to deploy to"
  default     = "starry-diode-376414"
}

variable "metric_name" {
  description = "Name of the log-based metric."
  default     = "compute_engine_internal_error_metric"
}

variable "alert_policy_name" {
  description = "The display name for the alert policy."
  default     = "Compute Engine Internal Error Alert"
}

variable "alert_channels" {
  description = "List of notification channels in which the alert will be delivered"
  type        = list(string)
  default     = ["projects/starry-diode-376414/notificationChannels/6311850573469835489"]
}
