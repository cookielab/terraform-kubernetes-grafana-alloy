locals {
  agent_name        = format("grafana-alloy-%s", var.agent_name)
  agent_config_key  = "config.river"
  url_metrics_write = var.metrics.backend_type == "mimir" ? format("%s/api/v1/push", trimsuffix(var.metrics.endpoint, "/")) : format("%s/api/v1/write", trimsuffix(var.metrics.endpoint, "/"))
  url_mimir_rules   = trimsuffix(var.metrics.endpoint, "/")

  agent_resources = {
    requests = {
      cpu    = var.agent_resources.requests.cpu
      memory = var.agent_resources.requests.memory
    }
    limits = {
      cpu    = var.agent_resources.limits.cpu == null ? var.agent_resources.requests.cpu : var.agent_resources.limits.cpu
      memory = var.agent_resources.limits.memory == null ? var.agent_resources.requests.memory : var.agent_resources.limits.memory
    }
  }

  agent_ports = var.otel.enabled ? [
    {
      name       = "http-otel"
      targetPort = var.otel.http_port
      port       = var.otel.http_port
      protocol   = "TCP"
    },
    {
      name       = "grpc-otel"
      targetPort = var.otel.grpc_port
      port       = var.otel.grpc_port
      protocol   = "TCP"
    },
  ] : []

}
