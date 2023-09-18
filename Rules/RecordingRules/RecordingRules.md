### Recording Rules
- https://training.promlabs.com/training/recording-rules/recording-rules-overview/rule-naming-conventions
- https://training.promlabs.com/training/recording-rules/recording-rules-overview/configuring-recording-rules
 
```bash
level: metric: operations

for:  sum by(job, path) (rate(http_requests_total{job="my-job"}[5m]))
naming: path:http_requests:rate5m
```

### Recording Rule:
```yaml
groups:
  - name: node_rules
    interval: 10s
    rules:
      - record: memory:node_memory_MemFree:memory_used_percents
        expr: 100 * (node_memory_MemFree_bytes / node_memory_MemTotal_bytes)

      - record: memory:node_memory_MemUsed:memory_used_percents
        expr: 100 - 100 * (node_memory_MemFree_bytes / node_memory_MemTotal_bytes)

      - record: filesystem:node_filesystem_Free:filesystem_free_percents
        expr: 100 * (node_filesystem_free_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})

      - record: filesystem:node_filesystem_Used:filesystem_used_percents
        expr: 100 - 100 * (node_filesystem_free_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"})
```

### Syntax Checking using `promtool`
```bash
promtool check rules /path/to/example.rules.yml
```
-  Store the rule inside the `/etc/prometheus/rules/` directory. Example: `/etc/prometheus/rules/node_rules.yaml`
-  Load the rule file inside the `prometheus.yaml`. In my case file is located at `/etc/prometheus/prometheus.yaml`
  
 <img width="977" alt="image" src="https://github.com/shamimice03/prometheus-grafana-workshop/assets/19708705/31eb8be1-9848-49a6-92d4-92bb0f9958d6">

