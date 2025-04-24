module "grafana_alloy" {
  source = "../../"

  agent_name              = "single${var.tenant_distinguisher}"
  agent_resources         = var.agent_resources
  clustering_enabled      = false
  chart_version           = var.chart_version
  controller_resources    = var.controller_resources
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_kind         = "deployment"
  kubernetes_namespace    = var.kubernetes_namespace
  image                   = var.image
  metrics                 = var.metrics
  otel                    = var.otel
  replicas                = 1
  global_tolerations      = var.global_tolerations
  integrations = {
    k8s_mimir_rules = true
  }

  config = concat(var.config, [
    var.k8s_mimir_rules.enabled ? <<-EOF
      k8s_mimir_rules "default" {
        sync_interval    = "${var.k8s_mimir_rules.sync_interval}"
        namespace_prefix = "${coalesce(var.k8s_mimir_rules.namespace_prefix, var.kubernetes_cluster_name)}"
        rule_match_labels = {
        %{for key, value in var.rule_match_labels~}
          ${key} = "${value}",
        %{endfor~}
        }
      }
      EOF
    : "", var.otel.enabled ? <<-EOF
      otel_process "default" {
        metrics_output = prometheus.remote_write.default.receiver
        otel_output    = otelcol.exporter.otelhttp.default.input
      }
      EOF
    : ""
  ])
}
