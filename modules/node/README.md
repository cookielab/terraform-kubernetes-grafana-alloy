# Grafana Agent Node Exporter Module

This module deploys Grafana Agent as a DaemonSet to collect node metrics from a Kubernetes cluster using node_exporter.

## Overview

The module runs Grafana Agent with node_exporter integration on each Kubernetes node to collect system-level metrics like:

- CPU usage
- Memory usage 
- Disk I/O
- Network statistics
- System load
- And other node-level metrics

The agent runs in privileged mode with access to host filesystem mounts to gather complete node metrics.
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
| <a name="input_k8s_node_exporter"></a> [k8s\_node\_exporter](#input\_k8s\_node\_exporter) | Grafana Agent scrape timings for K8S node\_exporter | <pre>object({<br>    scrape_interval = optional(string, "1m")<br>    scrape_timeout  = optional(string, "30s")<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Grafana Agent metrics endpoint of Prometheus-compatible receiver | <pre>object({<br>    endpoint = optional(string, "http://prometheus:9090/api/v1/write")<br>    tenant   = optional(string, "default")<br>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
