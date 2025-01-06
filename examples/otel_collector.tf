module "grafana_alloy_otel_collector" {
  source        = "git::ssh://git@github.com/cookielab/terraform-kubernetes-grafana-alloy.git//modules/otel-collector"
  chart_version = "0.10.1"

  otel = {
    endpoint                  = "https://tempo_url:443"
    service_graphs_dimensions = ["http.method"]
  }

  metrics = {
    endpoint = "mimir_url"
    tenant   = "mimir_tenant"
  }

  kubernetes_cluster_name = data.aws_eks_cluster.main.name
  kubernetes_namespace    = "default"

  agent_resources = {
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
  }

  image = {
    registry   = "docker.io"
    repository = "grafana/alloy"
  }
}
