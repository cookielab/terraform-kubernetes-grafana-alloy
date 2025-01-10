variable "kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "kubernetes_cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "replicas" {
  type        = number
  default     = 1
  description = "Number of Grafana Agent replicas"
}

variable "config" {
  type        = list(string)
  default     = []
  description = "Grafana Agent River config snippets"
}

variable "agent_resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string, "500m")
      memory = optional(string, "512Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, null)
      memory = optional(string, null)
    }), {})
  })
  default     = {}
  description = "Resources for the Grafana OTel agent"
}

variable "controller_resources" {
  type = object({
    requests = optional(object({
      cpu    = optional(string, "1m")
      memory = optional(string, "5Mi")
    }), {})
    limits = optional(object({
      cpu    = optional(string, "100m")
      memory = optional(string, "50Mi")
    }), {})
  })
  default     = {}
  description = "Resources for the Grafana Agent controller"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version of Grafana Agent"
  default     = "0.38.0"
}

variable "image" {
  type = object({
    registry   = optional(string, "docker.io")
    repository = optional(string, "grafana/agent")
  })
  default     = {}
  description = "Image registry for Grafana Agent"
}

variable "metrics" {
  type = object({
    endpoint     = optional(string, "http://mimir:9090")
    tenant       = optional(string, "default")
    backend_type = optional(string, "mimir")
  })
  default     = {}
  description = "Grafana Agent metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API."

  validation {
    condition     = contains(["mimir", "prometheus"], var.metrics.backend_type)
    error_message = "Valid values for metrics.backend_type are \"mimir\" or \"prometheus\"."
  }
}

variable "loki" {
  type = object({
    url                    = optional(string, "http://loki:3100")
    tenant_id              = optional(string, "default")
    username               = optional(string, "admin")
    password               = optional(string, "admin")
    scrape_pods_global     = optional(bool, false)
    scrape_pods_annotation = optional(string, "loki.logs.enabled")
  })
  default     = {}
  description = "Grafana Agent scrape settings for Loki logs"
}

variable "global_tolerations" {
  type = list(object({
    key      = string
    operator = string
    effect   = string
  }))
  default     = []
  description = "Global tolerations for the Grafana Agent"
}

variable "stability_level" {
  type        = string
  default     = "generally-available"
  description = "Stability level for the Grafana Agent"
}

variable "live_debug" {
  type        = bool
  default     = false
  description = "Enable live debug for the Grafana Agent"
}
