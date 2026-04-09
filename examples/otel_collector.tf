module "grafana_alloy_otel_collector" {
  source        = "git::ssh://git@github.com/cookielab/terraform-kubernetes-grafana-alloy.git//modules/otel-collector"
  chart_version = "1.0.2"
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

  ingress = {
    enabled            = true
    ingress_class_name = "nginx"
    hosts              = ["alloy-otel.example.com"]
    port               = 4318
  }

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
