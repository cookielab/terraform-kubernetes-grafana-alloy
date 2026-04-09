module "grafana_alloy" {
  source = "../../"

  agent_name              = "custom-scrape"
  agent_resources         = var.agent_resources
  clustering_enabled      = var.clustering_enabled
  chart_version           = var.chart_version
  controller_resources    = var.controller_resources
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_kind         = var.kubernetes_kind
  kubernetes_namespace    = var.kubernetes_namespace
  image                   = var.image
  metrics                 = var.metrics
  replicas                = var.replicas
  iam_role_arn            = var.iam_role_arn
  global_tolerations      = var.global_tolerations
  host_network            = var.host_network
  ingress                 = var.ingress
  pod_disruption_budget   = var.pod_disruption_budget
  autoscaling             = var.autoscaling
  otel = {
    enabled = false
  }
  config = concat(var.config, var.custom_scrape_config)
}
