#! /bin/bash

# `prometheus` user and group already exists

sudo rm -rf /tmp/*
sudo wget https://github.com/prometheus/alertmanager/releases/download/v0.26.0/alertmanager-0.26.0.linux-amd64.tar.gz -P /tmp
sudo tar xvf /tmp/alertmanager-0.26.0.linux-amd64.tar.gz --strip-components=1 -C /tmp
sudo rm -rf /tmp/alertmanager-0.26.0.linux-amd64.tar.gz -

sudo mkdir -p /var/lib/alertmanager
sudo mv -f /tmp/* /var/lib/alertmanager/

sudo mkdir -p /var/lib/alertmanager/data

sudo chown -R prometheus:prometheus /var/lib/alertmanager
sudo chmod -R 775 /var/lib/alertmanager

# Define the service unit file path
SERVICE_UNIT_FILE="/etc/systemd/system/alertmanager.service"

# Check if the service unit file already exists
if [ -e "$SERVICE_UNIT_FILE" ]; then
    echo "Service unit file $SERVICE_UNIT_FILE already exists."
    exit 1
fi

# Create the Prometheus service unit file
sudo tee "$SERVICE_UNIT_FILE" > /dev/null <<EOF
[Unit]
Description=Prometheus Alert Manager
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/var/lib/alertmanager/alertmanager --storage.path=/var/lib/alertmanager/data --config.file=/var/lib/alertmanager/alertmanager.yml

SyslogIdentifier=prometheus_alert_manager
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Reload systemd to apply the new unit file
sudo systemctl daemon-reload

# Start Prometheus service and enable it to start at boot
sudo systemctl start alertmanager
sudo systemctl enable alertmanager
