module "grafana_alloy" {
  source = "../../"

  agent_name              = "kafka"
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
  kafka_jmx_metrics       = var.kafka_jmx_metrics
  iam_role_arn            = var.iam_role_arn
  integrations = {
    kafka_jmx_metrics = true
  }
  global_tolerations = var.global_tolerations
  otel = {
    enabled = false
  }
  config = concat(var.config, [<<-EOF
    kafka_jmx_metrics "${var.kafka_jmx_metrics.distinguisher}" {
      scrape_interval = "${var.kafka_jmx_metrics.scrape_interval}"
      scrape_timeout  = "${var.kafka_jmx_metrics.scrape_timeout}"
      scrape_period   = "${var.kafka_jmx_metrics.scrape_period}"
      metrics_output  = prometheus.remote_write.default.receiver
    }
    EOF
  ])
}
