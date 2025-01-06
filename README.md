# Grafana Alloy Terraform Module

This module deploys Grafana Alloy to collect metrics/traces/logs from various sources in a Kubernetes cluster.

## Overview

The module is designed for flexible deployment of Grafana Alloy with different configurations:

- **Cluster Module** - Collects metrics from Kubernetes cluster (pods, services, kubelet, cAdvisor)
- **Node Module** - Collects node-level metrics using node_exporter
- **Kafka Module** - Collects JMX metrics from Kafka brokers
- **AWS Module** - Collects metrics from AWS services via CloudWatch
- **Single Module** - Collects traces and metrics using OpenTelemetry protocol, Prometheus Alert rules which needs to be single point of processing
- **OpenTelemetry Collector Module** - Collects telemetry data (traces and metrics) using the OpenTelemetry protocol and forwards them to Grafana Tempo and Mimir backends
- **Loki Logs Module** - Collects logs from Kubernetes pods and forwards them to Loki with support for annotation-based filtering and multi-tenancy


## Architecture

The module supports:

- Scaling to multiple replicas for high availability 
- Clustering for load distribution
- Flexible configuration using River format
- Collection of metrics to Prometheus-compatible endpoints
- Collection of logs to Loki
- Collection of traces and metrics via OpenTelemetry protocol
- Support for OpenTelemetry Collector deployment and configuration
- Configurable resource limits for agents

## Modules

The module contains the following submodules:

- `cluster` - For collecting Kubernetes metrics
- `node` - For collecting system metrics from nodes
- `kafka` - For collecting Kafka JMX metrics
- `aws` - For collecting AWS CloudWatch metrics
- `single` - For collecting OpenTelemetry traces and metrics, Prometheus Alert rules which needs to be single point of processing
- `otel-collector` - For collecting OpenTelemetry traces and metrics using the OpenTelemetry Collector protocol
- `loki-logs` - For collecting and forwarding Kubernetes pod logs to Loki

Each module can be used independently or in combination based on requirements.


# Grafana Alloy Terraform module

## Usage
### Cluster Module for k8s metrics

```
module "grafana_alloy_k8s" {
  source  = "./modules/cluster"

  kubernetes_cluster_name = "somecluster"
  kubernetes_namespace    = "cluster-apps"

  agent_name         = "clustered"
  clustering_enabled = true
  replicas           = 3

  config = [<<-EOF
    k8s_pods "my" {
      metrics_output = prometheus.remote_write.default.receiver
    }

    k8s_services "my" {
      metrics_output = prometheus.remote_write.default.receiver
    }

    k8s_cadvisor "my" {
      metrics_output = prometheus.remote_write.default.receiver
    }

    k8s_kubelet "my" {
      metrics_output = prometheus.remote_write.default.receiver
    }
    EOF
  ]

  metrics = {
    endpoint = "https://mimir.example.com:443/api/v1/push"
  }
}
```

### OTel example

```
module "grafana_alloy_otel" {
  source  = "./modules/otel-collector"

  kubernetes_cluster_name = "somecluster"
  kubernetes_namespace    = "cluster-apps"

  agent_name = "otel"

  config = [<<-EOF
    otel_process "my" {
      metrics_output = prometheus.remote_write.default.receiver
      traces_output  = otelcol.exporter.otelhttp.default.receiver
    }
    EOF
  ]

  metrics = {
    endpoint = "https://mimir.example.com:443/api/v1/push"
  }

  otel = {
    enabled  = true
    endpoint = "https://tempo.example.com:443"
  }
}
```
NOTE: OTel components are not cluster-capable and some require single point of processing (ie. traces)

### Loki Logs Module for k8s pod logs

```hcl
module "grafana_alloy_loki_logs" {
  source = "./modules/loki-logs"
  loki = {
    url = "http://loki-gateway.monitoring.svc.cluster.local:80/loki/api/v1/push"
    tenant_id = "default"
  }
  kubernetes_namespace = "monitoring"
  kubernetes_cluster_name = "utils"
}
```

For working examples, look into the submodules

### Kubernetes usage resources

```
  agent_resources = {
    requests = {
      cpu    = "100m"
      memory = "100Mi"
    }
    limits = {
      cpu    = "1"
      memory = "1Gi"
    }
  }
```

Please note, when limits are undefined, requests values are used for limits too.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3.0, < 2.0.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | >= 2.0.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | >= 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | >= 2.0.0 |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | >= 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.grafana_alloy](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map_v1.grafana_alloy](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_secret_v1.grafana_alloy](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_name"></a> [agent\_name](#input\_agent\_name) | Name of the Grafana Alloy. | `string` | n/a | yes |
| <a name="input_agent_resources"></a> [agent\_resources](#input\_agent\_resources) | Resources for the Grafana Alloy | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "100m")<br/>      memory = optional(string, "256Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, null)<br/>      memory = optional(string, null)<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Alloy | `string` | `"1.0.2"` | no |
| <a name="input_clustering_enabled"></a> [clustering\_enabled](#input\_clustering\_enabled) | Enable Grafana Alloy clustering. NOTE: This is only supported for certain kinds of resources - RTFM | `bool` | `false` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Alloy River configuration. Some configuration should be provided. You're encouraged to use the provided templates. You can also provide your completely own config with `default_config_enabled = false`. | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Alloy controller | <pre>object({<br/>    requests = optional(object({<br/>      cpu    = optional(string, "1m")<br/>      memory = optional(string, "5Mi")<br/>    }), {})<br/>    limits = optional(object({<br/>      cpu    = optional(string, "100m")<br/>      memory = optional(string, "50Mi")<br/>    }), {})<br/>  })</pre> | `{}` | no |
| <a name="input_default_config_enabled"></a> [default\_config\_enabled](#input\_default\_config\_enabled) | Enable default Grafana Alloy config templates. NOTE: Set this to `false` only if you want to use your own config without the enclosed templates. | `bool` | `true` | no |
| <a name="input_envs"></a> [envs](#input\_envs) | Additional environment variables for the Grafana Alloy. You can use this attribute to provide additional secrets without exposing them in the config map output. | `map(string)` | `{}` | no |
| <a name="input_global_tolerations"></a> [global\_tolerations](#input\_global\_tolerations) | Global tolerations for the Grafana Alloy | <pre>list(object({<br/>    key               = string<br/>    operator          = string<br/>    value             = optional(string)<br/>    effect            = string<br/>    tolerationSeconds = optional(number)<br/>  }))</pre> | `[]` | no |
| <a name="input_host_volumes"></a> [host\_volumes](#input\_host\_volumes) | Extra volumes to mount to the Grafana Alloy. This is needed for some integrations like node\_exporter. | <pre>list(object({<br/>    name       = string<br/>    host_path  = string<br/>    mount_path = string<br/>  }))</pre> | `[]` | no |
| <a name="input_iam_role_arn"></a> [iam\_role\_arn](#input\_iam\_role\_arn) | This role is for assuming by cloudwatch exporter | `string` | `""` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Alloy. This is meant to be used with custom pull-through proxies/registries. | <pre>object({<br/>    registry   = optional(string, "docker.io")<br/>    repository = optional(string, "grafana/alloy")<br/>  })</pre> | `{}` | no |
| <a name="input_integrations"></a> [integrations](#input\_integrations) | Grafana Alloy integrations configuration | <pre>object({<br/>    otel_collector       = optional(bool, false)<br/>    loki_logs            = optional(bool, false)<br/>    k8s_cadvisor         = optional(bool, false)<br/>    k8s_kubelet          = optional(bool, false)<br/>    k8s_mimir_rules      = optional(bool, false)<br/>    k8s_pods             = optional(bool, false)<br/>    k8s_services         = optional(bool, false)<br/>    node_exporter        = optional(bool, false)<br/>    aws_alb              = optional(bool, false)<br/>    aws_rds              = optional(bool, false)<br/>    aws_sqs              = optional(bool, false)<br/>    aws_mq               = optional(bool, false)<br/>    aws_opensearch       = optional(bool, false)<br/>    remote_write_metrics = optional(bool, true)<br/>    kafka_jmx_metrics    = optional(bool, false)<br/>  })</pre> | `{}` | no |
| <a name="input_k8s_pods"></a> [k8s\_pods](#input\_k8s\_pods) | Grafana Alloy scrape settings for K8S pods | <pre>object({<br/>    scrape_pods_global     = optional(bool, false)<br/>    scrape_pods_annotation = optional(string, "prometheus_io_scrape")<br/>  })</pre> | `{}` | no |
| <a name="input_kafka_jmx_metrics"></a> [kafka\_jmx\_metrics](#input\_kafka\_jmx\_metrics) | Grafana Alloy scrape JMX kafka metrics | <pre>object({<br/>    scrape_interval       = optional(string, "1m")<br/>    scrape_timeout        = optional(string, "30s")<br/>    scrape_period         = optional(string, "1m")<br/>    kafka_broker_list     = optional(list(string), [])<br/>    distinguisher         = optional(string, "default")<br/>    metrics_endpoint_path = optional(string, "/metrics")<br/>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name. NOTE: This gets injected into labels/attributes of all collected data. | `string` | n/a | yes |
| <a name="input_kubernetes_kind"></a> [kubernetes\_kind](#input\_kubernetes\_kind) | Grafana Alloy Kubernetes resource kind. Valid values are "deployment" or "daemonset". If you want to use clustering, you should use "deployment" with multiple replicas. | `string` | `"deployment"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace to deploy the Grafana Alloy into. NOTE: The namespace must exist and be available for deployment! | `string` | n/a | yes |
| <a name="input_kubernetes_security_context"></a> [kubernetes\_security\_context](#input\_kubernetes\_security\_context) | Kubernetes security context configuration for the Grafana Alloy. This is needed with node\_exporter to run privileged and as root (UID 0). | <pre>object({<br/>    runAsUser  = optional(number)<br/>    privileged = optional(bool)<br/>  })</pre> | `{}` | no |
| <a name="input_live_debug"></a> [live\_debug](#input\_live\_debug) | Enable live debug for the Grafana Alloy | `bool` | `false` | no |
| <a name="input_loki"></a> [loki](#input\_loki) | Grafana Alloy scrape settings for Loki logs | <pre>object({<br/>    url                    = optional(string, "http://loki:3100")<br/>    tenant_id              = optional(string, "default")<br/>    username               = optional(string, "admin")<br/>    password               = optional(string, "admin")<br/>    auth_enabled           = optional(bool, false)<br/>    scrape_pods_global     = optional(bool, true)<br/>    scrape_pods_annotation = optional(string, "loki.logs.enabled")<br/>  })</pre> | `{}` | no |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Alloy metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the base URL of the API. | <pre>object({<br/>    endpoint     = optional(string, "http://mimir:9090")<br/>    tenant       = optional(string, "default")<br/>    backend_type = optional(string, "mimir")<br/>    ssl_enabled  = optional(bool, true)<br/>  })</pre> | `{}` | no |
| <a name="input_otel"></a> [otel](#input\_otel) | Grafana Alloy OTel configuration. NOTE: There can be only one OTel receiver at the moment. | <pre>object({<br/>    http_port                 = optional(number, 4318)<br/>    grpc_port                 = optional(number, 4317)<br/>    endpoint                  = optional(string, "http://tempo:4318")<br/>    service_graphs_dimensions = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Grafana Alloy replicas. NOTE: Only valid for `kubernetes_kind = "deployment"`. | `number` | `1` | no |
| <a name="input_stability_level"></a> [stability\_level](#input\_stability\_level) | n/a | `string` | `"generally-available"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otel_endpoints"></a> [otel\_endpoints](#output\_otel\_endpoints) | Exposed OTel endpoints |
<!-- END_TF_DOCS -->
