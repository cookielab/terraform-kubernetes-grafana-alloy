resource "kubernetes_config_map_v1" "grafana_alloy" {
  metadata {
    name      = format("%s-config", local.agent_name)
    namespace = var.kubernetes_namespace
  }

  data = {
    (local.agent_config_key) = join("\n", concat(
      flatten(var.default_config_enabled ? [
        [
          var.integrations.k8s_cadvisor ? file("${path.module}/templates/k8s_cadvisor.river.tmpl") : "",
          var.integrations.k8s_kubelet ? file("${path.module}/templates/k8s_kubelet.river.tmpl") : "",
          var.integrations.k8s_mimir_rules ? file("${path.module}/templates/k8s_mimir_rules.river.tmpl") : "",
          var.integrations.k8s_pods ? templatefile("${path.module}/templates/k8s_pods.river.tmpl", {
            scrape_pods_global     = var.k8s_pods.scrape_pods_global
            scrape_pods_annotation = var.k8s_pods.scrape_pods_annotation
          }) : "",
          var.integrations.k8s_services ? file("${path.module}/templates/k8s_services.river.tmpl") : "",
          var.integrations.node_exporter ? file("${path.module}/templates/node_exporter.river.tmpl") : "",
          var.integrations.aws_alb ? templatefile("${path.module}/templates/aws_alb.river.tmpl", {
            scrape_interval = var.aws_alb.scrape_interval
            scrape_timeout  = var.aws_alb.scrape_timeout
            scrape_period   = var.aws_alb.scrape_period
            region          = var.aws_alb.region
          }) : "",
          var.integrations.aws_rds ? templatefile("${path.module}/templates/aws_rds.river.tmpl", {
            scrape_interval = var.aws_rds.scrape_interval
            scrape_timeout  = var.aws_rds.scrape_timeout
            scrape_period   = var.aws_rds.scrape_period
            region          = var.aws_rds.region
            search_tags     = var.aws_rds.search_tags
          }) : "",
          var.integrations.aws_sqs ? templatefile("${path.module}/templates/aws_sqs.river.tmpl", {
            scrape_interval = var.aws_sqs.scrape_interval
            scrape_timeout  = var.aws_sqs.scrape_timeout
            scrape_period   = var.aws_sqs.scrape_period
            region          = var.aws_sqs.region
          }) : "",
          var.integrations.aws_mq ? templatefile("${path.module}/templates/aws_mq.river.tmpl", {
            scrape_interval = var.aws_mq.scrape_interval
            scrape_timeout  = var.aws_mq.scrape_timeout
            scrape_period   = var.aws_mq.scrape_period
            region          = var.aws_mq.region
          }) : "",
          var.integrations.aws_opensearch ? templatefile("${path.module}/templates/aws_opensearch.river.tmpl", {
            scrape_interval = var.aws_opensearch.scrape_interval
            scrape_timeout  = var.aws_opensearch.scrape_timeout
            scrape_period   = var.aws_opensearch.scrape_period
            region          = var.aws_opensearch.region
          }) : "",
          var.integrations.remote_write_metrics ? file("${path.module}/templates/remote_write_metrics.river.tmpl") : "",
          var.integrations.kafka_jmx_metrics ? templatefile("${path.module}/templates/kafka_jmx_metrics.river.tmpl", {
            addresses             = var.kafka_jmx_metrics.kafka_broker_list
            metrics_endpoint_path = var.kafka_jmx_metrics.metrics_endpoint_path
          }) : "",
          var.integrations.otel_collector ? templatefile("${path.module}/templates/otel_collector.river.tmpl", {
            otel_http_port                 = var.otel.http_port
            otel_grpc_port                 = var.otel.grpc_port
            otel_service_graphs_dimensions = var.otel.service_graphs_dimensions
          }) : "",
          var.integrations.loki_logs ? templatefile("${path.module}/templates/loki_pod_logs.river.tmpl", {
            scrape_pods_global     = var.loki.scrape_pods_global
            scrape_pods_annotation = var.loki.scrape_pods_annotation
            loki_auth_enabled      = var.loki.auth_enabled
          }) : "",
        ],
      ] : []),
      flatten(var.config),
    ))
  }
}
