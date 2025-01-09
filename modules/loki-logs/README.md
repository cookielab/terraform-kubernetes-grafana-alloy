# Grafana Agent Loki Logs Module

This module deploys Grafana Agent to collect logs from Kubernetes pods and send them to Loki.

## Overview

The module is designed to collect logs from Kubernetes pods and forward them to a Loki instance. Key features include:

- Automatic pod log collection based on annotations
- Global pod log collection option
- Configurable Loki endpoint and authentication
- Support for multi-tenant Loki deployments

The agent runs as a deployment and collects logs from:

- Kubernetes pods marked with the specified annotation (default: loki.logs.enabled)
- All pods in the cluster when global collection is enabled
- Container stdout/stderr streams

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_grafana_agent"></a> [grafana\_agent](#module\_grafana\_agent) | ../../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_resources"></a> [agent\_resources](#input\_agent\_resources) | Resources for the Grafana OTel agent | <pre>object({<br>    requests = optional(object({<br>      cpu    = optional(string, "500m")<br>      memory = optional(string, "512Mi")<br>    }), {})<br>    limits = optional(object({<br>      cpu    = optional(string, null)<br>      memory = optional(string, null)<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_chart_version"></a> [chart\_version](#input\_chart\_version) | Helm chart version of Grafana Agent | `string` | `"0.38.0"` | no |
| <a name="input_config"></a> [config](#input\_config) | Grafana Agent River config snippets | `list(string)` | `[]` | no |
| <a name="input_controller_resources"></a> [controller\_resources](#input\_controller\_resources) | Resources for the Grafana Agent controller | <pre>object({<br>    requests = optional(object({<br>      cpu    = optional(string, "1m")<br>      memory = optional(string, "5Mi")<br>    }), {})<br>    limits = optional(object({<br>      cpu    = optional(string, "100m")<br>      memory = optional(string, "50Mi")<br>    }), {})<br>  })</pre> | `{}` | no |
| <a name="input_image"></a> [image](#input\_image) | Image registry for Grafana Agent | <pre>object({<br>    registry   = optional(string, "docker.io")<br>    repository = optional(string, "grafana/agent")<br>  })</pre> | `{}` | no |
| <a name="input_k8s_cadvisor"></a> [k8s\_cadvisor](#input\_k8s\_cadvisor) | Grafana Agent scrape timings for K8S cadvisor | <pre>object({<br>    scrape_interval = optional(string, "1m")<br>    scrape_timeout  = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_k8s_kubelet"></a> [k8s\_kubelet](#input\_k8s\_kubelet) | Grafana Agent scrape timings for K8S kubelet | <pre>object({<br>    scrape_interval = optional(string, "1m")<br>    scrape_timeout  = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_k8s_pods"></a> [k8s\_pods](#input\_k8s\_pods) | Grafana Agent scrape timings for K8S pods | <pre>object({<br>    scrape_interval = optional(string, "1m")<br>    scrape_timeout  = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_k8s_services"></a> [k8s\_services](#input\_k8s\_services) | Grafana Agent scrape timings for K8S services | <pre>object({<br>    scrape_interval = optional(string, "1m")<br>    scrape_timeout  = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Agent metrics endpoint of Prometheus-compatible receiver | <pre>object({<br>    endpoint = optional(string, "http://prometheus:9090/api/v1/write")<br>    tenant   = optional(string, "default")<br>  })</pre> | `{}` | no |
| <a name="input_replicas"></a> [replicas](#input\_replicas) | Number of Grafana Agent replicas | `number` | `1` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
