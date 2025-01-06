# Grafana Agent Kafka Module

This module deploys Grafana Agent to collect metrics from Kafka clusters in Kubernetes.

## Overview

The module is designed to collect JMX metrics from Kafka brokers using Grafana Agent. It collects metrics such as:

- Message throughput
- Partition sizes
- Latencies
- Number of connected producers/consumers  
- Broker resource utilization

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
| <a name="input_kafka_jmx_metrics"></a> [kafka\_jmx\_metrics](#input\_kafka\_jmx\_metrics) | Settings for Kafka JMX metrics collection | <pre>object({<br>    scrape_interval = optional(string, "1m")<br>    scrape_timeout  = optional(string, "30s")<br>    scrape_period   = optional(string, "1m")<br>    distinguisher   = optional(string, "default")<br>  })</pre> | `{}` | no |
| <a name="input_kubernetes_cluster_name"></a> [kubernetes\_cluster\_name](#input\_kubernetes\_cluster\_name) | Kubernetes cluster name | `string` | n/a | yes |
| <a name="input_kubernetes_namespace"></a> [kubernetes\_namespace](#input\_kubernetes\_namespace) | Kubernetes namespace | `string` | n/a | yes |
| <a name="input_metrics"></a> [metrics](#input\_metrics) | Prometheus-compatible metrics receiver endpoint | <pre>object({<br>    endpoint = optional(string, "http://prometheus:9090/api/v1/write")<br>    tenant   = optional(string, "default")<br>  })</pre> | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->

