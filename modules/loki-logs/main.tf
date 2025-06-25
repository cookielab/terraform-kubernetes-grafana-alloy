module "grafana_alloy" {
  source = "../../"

  agent_name              = "loki-logs"
  agent_resources         = var.agent_resources
  clustering_enabled      = var.loki.scrape_logs_method == "file" ? false : var.clustering_enabled
  chart_version           = var.chart_version
  controller_resources    = var.controller_resources
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_kind         = var.loki.scrape_logs_method == "file" ? "daemonset" : "deployment"
  kubernetes_namespace    = var.kubernetes_namespace
  image                   = var.image
  metrics                 = var.metrics
  stability_level         = var.stability_level
  live_debug              = var.live_debug
  aws                     = var.aws
  replicas                = var.replicas
  pod_disruption_budget   = var.pod_disruption_budget

  kubernetes_security_context = var.loki.scrape_logs_method == "file" ? {
    runAsUser  = 0
    privileged = true
    } : {
    runAsUser  = 473
    privileged = false
  }
  host_volumes = var.loki.scrape_logs_method == "file" ? [
    {
      name       = "varlog"
      host_path  = "/var/log"
      mount_path = "/var/log"
    },
  ] : []
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
