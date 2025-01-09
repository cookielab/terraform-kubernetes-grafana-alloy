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

<!-- BEGIN_TF_DOCS -->
# Grafana Alloy Terraform module

## Usage

```
module "grafana_agent" {
  source  = "..."
  version = "..."

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
module "grafana_agent" {
  source  = "..."
  version = "..."

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

---

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
| [helm_release.grafana_agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kubernetes_config_map_v1.grafana_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/config_map_v1) | resource |
| [kubernetes_secret_v1.grafana_agent](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/secret_v1) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_name"></a> [agent\_name](#input\_agent\_name) | Name of the Grafana Agent. | `string` | n/a | yes |
| <a name="input_agent_resources"></a> [agent\_resources](#input\_agent\_resources) | Resources for the Grafana Agent | <pre>object({<br>    requests = optional(object({<br>      cpu    = optional(string, "100m")<br>      memory = optional(string, "256Mi")<br>    }), {})<br>    limits = optional(object({<br>      cpu    = optional(string, null)<br>      memory = optional(string, null)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Agent | `string` | `"0.38.0"` | no |
| <a name="input_clustering_enabled"></a> [clustering\_enabled](#input\_clustering\_enabled) | Enable Grafana Agent clustering. NOTE: This is only supported for certain kinds of resources - RTFM | `bool` | `false` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Agent River configuration. Some configuration should be provided. You're encouraged to use the provided templates. You can also provide your completely own config with `default_config_enabled = false`. | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Agent controller | <pre>object({<br>    requests = optional(object({<br>      cpu    = optional(string, "1m")<br>      memory = optional(string, "5Mi")<br>    }), {})<br>    limits = optional(object({<br>      cpu    = optional(string, "100m")<br>      memory = optional(string, "50Mi")<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_default_config_enabled"></a> [default\_config\_enabled](#input\_default\_config\_enabled) | Enable default Grafana Agent config templates. NOTE: Set this to `false` only if you want to use your own config without the enclosed templates. | `bool` | `true` | no |
| <a name="input_envs"></a> [envs](#input\_envs) | Additional environment variables for the Grafana Agent | `map(string)` | `{}` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Agent. This is meant to be used with custom pull-through proxies/registries. | <pre>object({<br>    registry   = optional(string, "docker.io")<br>    repository = optional(string, "grafana/agent")<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name. NOTE: This gets injected into labels/attributes of all collected data. | `string` | n/a | yes |
| <a name="input_kubernetes_kind"></a> [kubernetes\_kind](#input\_kubernetes\_kind) | Grafana Agent Kubernetes resource kind. Valid values are "deployment" or "daemonset". If you want to use clustering, you should use "deployment" with multiple replicas. | `string` | `"deployment"` | no |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace to deploy the Grafana Agent into. NOTE: The namespace must exist and be available for deployment! | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Agent metrics endpoint of Prometheus-compatible receiver. NOTE: You must provide the full URL of the remote\_write API endpoint. | <pre>object({<br>    endpoint = optional(string, "http://prometheus:9090/api/v1/write")<br>    tenant   = optional(string, "default")<br>  })</pre> | `{}` | no |
| <a name="input_otel"></a> [otel](#input\_otel) | Grafana Agent OTel configuration. NOTE: There can be only one OTel receiver at the moment. | <pre>object({<br>    enabled   = optional(bool, false)<br>    http_port = optional(number, 4318)<br>    grpc_port = optional(number, 4317)<br>    endpoint  = optional(string, "")<br>  })</pre> | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Grafana Agent replicas. NOTE: Only valid for `kubernetes_kind = "deployment"`. | `number` | `1` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_otel_endpoints"></a> [otel\_endpoints](#output\_otel\_endpoints) | Exposed OTel endpoints |
<!-- END_TF_DOCS -->
