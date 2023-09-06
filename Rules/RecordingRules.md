### Naming conventions 
- https://training.promlabs.com/training/recording-rules/recording-rules-overview/rule-naming-conventions
```
level: metric: operations

for:  sum by(job, path) (rate(http_requests_total{job="my-job"}[5m]))
naming: path:http_requests:rate5m
```

### Recording Rule:
```
groups:
  - name: node_rules
    interval: 10s
    rules:
      - record: node_memory_MemFree_percent:
        expr: 100 - (100 * node_memory_MemFree_bytes / node_memory_MemTotal_bytes)

      - record: node_filesystem_free_percent
        expr: 100 * node_filesystem_free_bytes{mountpoint="/"} / node_filesystem_size_bytes{mountpoint="/"}
```
