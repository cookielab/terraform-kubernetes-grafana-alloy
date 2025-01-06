module "grafana_alloy" {
  source = "../../"

  agent_name              = "clustered"
  agent_resources         = var.agent_resources
  clustering_enabled      = true
  chart_version           = var.chart_version
  controller_resources    = var.controller_resources
  kubernetes_cluster_name = var.kubernetes_cluster_name
  kubernetes_kind         = "deployment"
  kubernetes_namespace    = var.kubernetes_namespace
  image                   = var.image
  metrics                 = var.metrics
  replicas                = var.replicas
  integrations = {
    k8s_cadvisor = true
    k8s_kubelet  = true
    k8s_pods     = true
    k8s_services = true
  }
  global_tolerations = var.global_tolerations
  config = concat(var.config, [<<-EOF
    k8s_pods "default" {
      scrape_interval = "${var.k8s_pods.scrape_interval}"
      scrape_timeout  = "${var.k8s_pods.scrape_timeout}"
      metrics_output  = prometheus.remote_write.default.receiver
    }

    k8s_services "default" {
      scrape_interval = "${var.k8s_services.scrape_interval}"
      scrape_timeout  = "${var.k8s_services.scrape_timeout}"
      metrics_output  = prometheus.remote_write.default.receiver
    }

    k8s_cadvisor "default" {
      scrape_interval = "${var.k8s_cadvisor.scrape_interval}"
      scrape_timeout  = "${var.k8s_cadvisor.scrape_timeout}"
      metrics_output  = prometheus.remote_write.default.receiver
    }

    k8s_kubelet "default" {
      scrape_interval = "${var.k8s_kubelet.scrape_interval}"
      scrape_timeout  = "${var.k8s_kubelet.scrape_timeout}"
      metrics_output  = prometheus.remote_write.default.receiver
    }
    EOF
  ])
}
