# Grafana Agent AWS Module

This module deploys Grafana Agent to collect metrics from AWS services via CloudWatch.

## Overview

The module is designed to collect various metrics from AWS services including:

- Amazon RDS metrics
- Amazon OpenSearch metrics  
- Amazon SQS metrics
- Other CloudWatch metrics

The agent runs as a deployment and collects metrics from:

- AWS CloudWatch API to gather service metrics
- Supports collecting metrics from multiple AWS regions
- Allows filtering and aggregation of metrics before sending

The module supports scaling to multiple replicas for high availability and load distribution when collecting metrics.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.4.0, < 2.0.0 |

## Providers

No providers.

## Modules

No modules.

## Resources

No resources.

## Inputs

No inputs.

## Outputs

No outputs.
<!-- END_TF_DOCS -->
