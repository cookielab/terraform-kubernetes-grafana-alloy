resource "kubernetes_secret_v1" "grafana_alloy" {
  metadata {
    name      = local.agent_name
    namespace = var.kubernetes_namespace
  }

  data = merge(var.envs,
    var.otel.enabled ? {
      GRAFANA_AGENT_OTEL_ENDPOINT = var.otel.endpoint
    } : {},
    {
      GRAFANA_AGENT_METRICS_ENDPOINT     = local.url_metrics_write
      GRAFANA_AGENT_MIMIR_RULES_ENDPOINT = local.url_mimir_rules
      GRAFANA_AGENT_METRICS_TENANT       = var.metrics.tenant
      GRAFANA_AGENT_K8S_CLUSTER          = var.kubernetes_cluster_name
    }
  )
}

