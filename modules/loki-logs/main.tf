module "grafana_alloy" {
  source = "../../"

  agent_name              = "loki-logs"
  agent_resources         = var.agent_resources
  clustering_enabled      = false
  chart_version           = var.chart_version
  controller_resources    = var.controller_resources
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_kind         = "deployment"
  kubernetes_namespace    = var.kubernetes_namespace
  image                   = var.image
  metrics                 = var.metrics
  stability_level         = var.stability_level
  replicas                = 1
  integrations = {
    loki_logs = true
  }
  loki               = var.loki
  global_tolerations = var.global_tolerations
  config = concat(var.config, [<<-EOF
    loki_pod_logs "default" {
    }
    EOF
  ])
}
