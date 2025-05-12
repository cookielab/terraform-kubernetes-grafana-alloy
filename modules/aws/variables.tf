variable "kubernetes_namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "kubernetes_cluster_name" {
  type        = string
  description = "Kubernetes cluster name"
}

variable "config" {
  type        = list(string)
  default     = []
  description = "Grafana Alloy River config snippets"
}

variable "iam_role_arn" {
  type        = string
  default     = ""
  description = "This role is for assuming by cloudwatch exporter"
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
  description = "Resources for the Grafana Alloy controller"
}

variable "chart_version" {
  type        = string
  description = "Helm chart version of Grafana Alloy"
  default     = "1.0.2"
}

variable "image" {
  type = object({
    registry   = optional(string, "docker.io")
    repository = optional(string, "grafana/alloy")
  })
  default     = {}
  description = "Image registry for Grafana Alloy"
}

variable "metrics" {
  type = object({
    endpoint     = optional(string, "http://mimir:9090")
    tenant       = optional(string, "default")
    backend_type = optional(string, "mimir")
    ssl_enabled  = optional(bool, true)
  })
  default     = {}
  description = "Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. Mimir and Promethes backends are supported."

  validation {
    condition     = contains(["mimir", "prometheus"], var.metrics.backend_type)
    error_message = "Valid values for metrics.backend_type are \"mimir\" or \"prometheus\"."
  }
}

variable "aws_alb" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws ALB metrics"
}

variable "aws_rds" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws RDS metrics"
}

variable "aws_mq" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws MQ metrics"
}

variable "aws_sqs" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape aws SQS metrics"
}

variable "aws_opensearch" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
  })
  default     = {}
  description = "Grafana Alloy scrape aws opensearch cloudwatch metrics"
}

variable "global_tolerations" {
  type = list(object({
    key      = string
    operator = string
    effect   = string
  }))
  default     = []
  description = "Global tolerations for the Grafana Alloy"
}

variable "integrations" {
  type = object({
    otel_collector       = optional(bool, false)
    loki_logs            = optional(bool, false)
    k8s_cadvisor         = optional(bool, false)
    k8s_kubelet          = optional(bool, false)
    k8s_mimir_rules      = optional(bool, false)
    k8s_pods             = optional(bool, false)
    k8s_services         = optional(bool, false)
    node_exporter        = optional(bool, false)
    aws_alb              = optional(bool, true)
    aws_rds              = optional(bool, true)
    aws_sqs              = optional(bool, true)
    aws_mq               = optional(bool, true)
    aws_opensearch       = optional(bool, true)
    remote_write_metrics = optional(bool, true)
    kafka_jmx_metrics    = optional(bool, false)
  })
  default     = {}
  description = "Grafana Alloy integrations configuration"
}

variable "aws_alb" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape settings for AWS ALB"
}

variable "aws_rds" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape settings for AWS RDS"
}

variable "aws_sqs" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape settings for AWS SQS"
}

variable "aws_mq" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
    search_tags     = optional(map(string), {})
  })
  default     = {}
  description = "Grafana Alloy scrape settings for AWS MQ"
}

variable "aws_opensearch" {
  type = object({
    scrape_interval = optional(string, "1m")
    scrape_timeout  = optional(string, "30s")
    scrape_period   = optional(string, "1m")
    region          = optional(string, "eu-west-1")
  })
  default     = {}
  description = "Grafana Alloy scrape settings for AWS OpenSearch"
}
