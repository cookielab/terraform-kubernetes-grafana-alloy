resource "helm_release" "grafana_alloy" {
  repository = "https://grafana.github.io/helm-charts"
  chart      = "alloy"
  version    = var.chart_version
  name       = local.agent_name
  namespace  = var.kubernetes_namespace
  timeout    = 600

  values = [yamlencode({
    image = var.image
    controller = {
      type      = var.kubernetes_kind
      resources = var.controller_resources
      replicas  = var.replicas
      volumes = {
        extra = [for volume in var.host_volumes : {
          name = volume.name
          hostPath = {
            path = volume.host_path
          }
        }]
      }
      tolerations = var.global_tolerations
    }
    alloy = merge(var.integrations.otel_collector ? { extraPorts = [
      {
        name       = "http-otel"
        targetPort = var.otel.http_port
        port       = var.otel.http_port
        protocol   = "TCP"
      },
      {
        name       = "grpc-otel"
        targetPort = var.otel.grpc_port
        port       = var.otel.grpc_port
        protocol   = "TCP"
      }]
      } : {}, {
      mode            = "flow"
      liveDebug       = var.live_debug
      securityContext = var.kubernetes_security_context
      clustering = {
        enabled = var.clustering_enabled
      }
      stabilityLevel = var.stability_level
      configMap = {
        create = false
        name   = kubernetes_config_map_v1.grafana_alloy.metadata[0].name
        key    = local.agent_config_key
      }
      resources = local.agent_resources
      envFrom = [{
        secretRef = {
          name = kubernetes_secret_v1.grafana_alloy.metadata[0].name
        }
      }]
      mounts = {
        extra = [for mount in var.host_volumes : {
          name      = mount.name
          mountPath = mount.mount_path
        }]
      }
    })
    }),
    var.iam_role_arn != "" ? yamlencode({
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.iam_role_arn
        }
      }
    }) : yamlencode({})
  ]
}
