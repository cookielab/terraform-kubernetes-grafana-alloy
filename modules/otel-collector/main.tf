module "grafana_alloy" {
  source = "../../"

  agent_name              = "otel-collector"
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
  stability_level         = var.stability_level
  global_tolerations      = var.global_tolerations
  integrations = {
    otel_collector = true
  }
  otel = {
    endpoint                  = var.otel.endpoint
    http_port                 = var.otel.http_port
    grpc_port                 = var.otel.grpc_port
    service_graphs_dimensions = var.otel.service_graphs_dimensions
  }
  config = concat(var.config, [<<-EOF
    otel_collector "default" {
    metrics_output  = prometheus.remote_write.default.receiver
    traces_output = sys.env("GRAFANA_ALLOY_OTEL_ENDPOINT")
    }
    EOF
  ])
}
