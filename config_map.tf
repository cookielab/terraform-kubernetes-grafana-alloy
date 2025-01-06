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
          var.integrations.k8s_pods ? file("${path.module}/templates/k8s_pods.river.tmpl") : "",
          var.integrations.k8s_services ? file("${path.module}/templates/k8s_services.river.tmpl") : "",
          var.integrations.node_exporter ? file("${path.module}/templates/node_exporter.river.tmpl") : "",
          var.integrations.aws_alb ? file("${path.module}/templates/aws_alb.river.tmpl") : "",
          var.integrations.aws_rds ? file("${path.module}/templates/aws_rds.river.tmpl") : "",
          var.integrations.aws_sqs ? file("${path.module}/templates/aws_sqs.river.tmpl") : "",
          var.integrations.aws_mq ? file("${path.module}/templates/aws_mq.river.tmpl") : "",
          var.integrations.aws_opensearch ? file("${path.module}/templates/aws_opensearch.river.tmpl") : "",
          var.integrations.remote_write_metrics ? file("${path.module}/templates/remote_write_metrics.river.tmpl") : "",
          var.integrations.kafka_jmx_metrics ? templatefile("${path.module}/templates/kafka_jmx_metrics.river.tmpl", {
            addresses             = var.kafka_jmx_metrics.kafka_broker_list
            metrics_endpoint_path = var.kafka_jmx_metrics.metrics_endpoint_path
          }) : "",
        ],
        var.otel.enabled ? [
          templatefile("${path.module}/templates/otel_ingest.river.tmpl", {
            otel_http_port = format("%d", var.otel.http_port)
            otel_grpc_port = format("%d", var.otel.grpc_port)
          }),
          templatefile("${path.module}/templates/otel_process.river.tmpl", {
            otel_http_port = format("%d", var.otel.http_port)
            otel_grpc_port = format("%d", var.otel.grpc_port)
          }),
          file("${path.module}/templates/otel.river.tmpl"),
        ] : [],
      ] : []),
      flatten(var.config),
    ))
  }
}
