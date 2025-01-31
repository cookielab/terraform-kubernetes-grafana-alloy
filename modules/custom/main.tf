module "grafana_alloy" {
  source = "../../"

  agent_name              = "custom-scrape"
  agent_resources         = var.agent_resources
  clustering_enabled      = false
  chart_version           = var.chart_version
  controller_resources    = var.controller_resources
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_kind         = "deployment"
  kubernetes_namespace    = var.kubernetes_namespace
  image                   = var.image
  metrics                 = var.metrics
  replicas                = 1
  iam_role_arn            = var.iam_role_arn
  global_tolerations      = var.global_tolerations
  otel = {
    enabled = false
  }
  config = concat(var.config, var.custom_scrape_config)
}
