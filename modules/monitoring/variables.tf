variable "project_id" {
    description = "Project in which to create monitoring resources"
    type = string
}

variable "notification_email_address" {
    description = "If specified, an email notification will be configured for this address."
    type = string
    default = "user@company"
}

variable "instance_groups" {
    type = map(object({
      min_threshold = number
    }))
    default = null
}