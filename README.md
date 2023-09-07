# prometheus-grafana-workshop

### `prometheus.yaml`
```yaml
# my global config
global:
  scrape_interval: 15s # Set the scrape interval to every 15 seconds. Default is every 1 minute.
  evaluation_interval: 15s # Evaluate rules every 15 seconds. The default is every 1 minute.
  # scrape_timeout is set to the global default (10s).

# Alertmanager configuration
alerting:
  alertmanagers:
    - static_configs:
        - targets:
           - localhost:9093

# Load rules once and periodically evaluate them according to the global 'evaluation_interval'.
rule_files:
   - "rules/alerts.yaml"
   - "rules/alerts2.yaml"
   - "rules/alerts3.yaml"
   - "rules/node_rules.yaml"
  # - "second_rules.yml"

# A scrape configuration containing exactly one endpoint to scrape:
# Here it's Prometheus itself.
scrape_configs:
  # The job name is added as a label `job=<job_name>` to any timeseries scraped from this config.
  - job_name: "prometheus"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["localhost:9090"]
  - job_name: "application-server_1"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["10.2.6.159:9100"]
        labels:
          task: node_exporter
          instance_type: amazonlinux2
  - job_name: "application-server_2"

    # metrics_path defaults to '/metrics'
    # scheme defaults to 'http'.

    static_configs:
      - targets: ["10.2.10.12:9100"]
        labels:
          task: node_exporter
          instance_type: amazonlinux2
```

<img width="1424" alt="Screenshot 2023-09-08 at 0 35 43" src="https://github.com/shamimice03/prometheus-grafana-workshop/assets/19708705/0c9ad5cd-f601-4073-a831-487399b6c879">
