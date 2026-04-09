variable "otlp_bearer_token" {
  type      = string
  sensitive = true
}

# Single-instance OTel Collector with Traefik ingress and Bearer Token auth
module "grafana_alloy_otel_collector" {
  source        = "git::ssh://git@github.com/cookielab/terraform-kubernetes-grafana-alloy.git//modules/otel-collector?ref=v1.0.6-rc3"
  chart_version = "1.0.2"

  kubernetes_cluster_name = data.aws_eks_cluster.main.name
  kubernetes_namespace    = "monitoring"

  # Custom Helm release name: results in "grafana-alloy-otel-anthropic"
  agent_name = "otel-anthropic"

  # Single instance — no clustering, no HPA
  replicas           = 1
  clustering_enabled = false

  otel = {
    endpoint                  = "https://tempo.example.com:443"
    service_graphs_dimensions = ["http.method"]

    # Require Bearer Token on all OTLP receivers (HTTP + gRPC)
    bearer_token = var.otlp_bearer_token
  }

  metrics = {
    endpoint = "https://mimir.example.com/api/v1/push"
    tenant   = "my-tenant"
  }

  ingress = {
    enabled            = true
    ingress_class_name = "traefik-prod"
    hosts              = ["otel-anthropic.carsdata.com"]
    port               = 4318
    tls = [
      {
        secret_name = "otel-anthropic-tls"
        hosts       = ["otel-anthropic.carsdata.com"]
      }
    ]
  }

  agent_resources = {
    requests = {
      cpu    = "100m"
      memory = "256Mi"
    }
    limits = {
      cpu    = "1"
      memory = "512Mi"
    }
  }
}
