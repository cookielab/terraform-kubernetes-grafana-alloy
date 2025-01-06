resource "kubernetes_secret_v1" "grafana_alloy" {
  metadata {
    name      = local.agent_name
    namespace = var.kubernetes_namespace
  }

  data = merge(var.envs,
    var.integrations.otel_collector ? {
      GRAFANA_ALLOY_OTEL_ENDPOINT = var.otel.endpoint
    } : {},
    var.integrations.loki_logs ? {
      LOKI_URL       = var.loki.url
      LOKI_TENANT_ID = var.loki.tenant_id
      LOKI_USERNAME  = var.loki.username
      LOKI_PASSWORD  = var.loki.password
    } : {},
    {
      GRAFANA_ALLOY_METRICS_ENDPOINT     = local.url_metrics_write
      GRAFANA_ALLOY_MIMIR_RULES_ENDPOINT = local.url_mimir_rules
      GRAFANA_ALLOY_METRICS_TENANT       = var.metrics.tenant
      GRAFANA_ALLOY_K8S_CLUSTER          = var.kubernetes_cluster_name
    }
  )
}

