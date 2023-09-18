Docs on:
- Relabel_configs: https://grafana.com/blog/2022/03/21/how-relabeling-in-prometheus-works/
  
```yaml
# prometheus.yaml

  # omitted
  - job_name: "sd_test"
    ec2_sd_configs:
      - port: 9090
        region: ap-northeast-1
        refresh_interval: 60s
        access_key: <> 
        secret_key: <>
        filters:
        - name: tag:Env
          values:
          - prometheus*
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Name, __meta_ec2_private_ip]
        target_label: instance
      - source_labels: [__meta_ec2_tag_Env]
        regex: prometheus*
        action: keep
      - source_labels: [__meta_ec2_public_ip]
        replacement: $1:9100
        target_label: __address__
      - source_labels: [__meta_ec2_tag_Env]
        target_label: test
```
### Before adding `relabel_configs`:
![Alt text](<Screenshot 2023-09-18 at 21.35.49.png>)

### Create new label
```yaml
    relabel_configs:
      - source_labels: [__meta_ec2_tag_Name, __meta_ec2_private_ip]
        target_label: instance
```
![Alt text](<Screenshot 2023-09-18 at 21.43.15.png>)

### `keep` and `drop`
if requirement meets `keep` or `drop`
```yaml
      - source_labels: [__meta_ec2_tag_Env]
        regex: prometheus.*
        action: keep
```

### Replace target address from `private` to `public` ip:
```yaml
      - source_labels: [__meta_ec2_public_ip]
        replacement: $1:9100
        target_label: __address__
```
![Alt text](<Screenshot 2023-09-18 at 21.53.59.png>)

### add new label
```yaml
      - source_labels: [__meta_ec2_tag_Env]
        target_label: test
```
![Alt text](<Screenshot 2023-09-18 at 22.14.34.png>)

### Add new label 
```yaml
      - source_labels: [__meta_ec2_tag_Env, __meta_ec2_tag_Name]
        separator: "@"
        regex: "(.*)@(.*)"
        replacement: "${1}/${2}_test_label"
        target_label: test_label
        action: replace
```
![Alt text](<Screenshot 2023-09-18 at 23.13.15.png>)

