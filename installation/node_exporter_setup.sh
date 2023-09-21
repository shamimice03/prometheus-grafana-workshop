#!/bin/bash
set -x  # Enable debugging output

# Update the package list and upgrade installed packages
sudo yum update -y

# Upgrade the system to the latest available packages
sudo yum upgrade -y

# Install wget
sudo yum install wget -y 

# Create a system group and user for Prometheus with /sbin/nologin shell
sudo groupadd --system prometheus
sudo useradd -s /sbin/nologin --system -g prometheus prometheus

# Create a directory to store Node Exporter binaries
sudo mkdir -p /var/lib/node

# Download and extract the Node Exporter binaries from the Prometheus GitHub release
wget https://github.com/prometheus/node_exporter/releases/download/v1.6.1/node_exporter-1.6.1.linux-amd64.tar.gz -P /tmp
sudo tar xvf /tmp/node_exporter-1.6.1.linux-amd64.tar.gz  --strip-components=1 -C /tmp

# Move Node Exporter binaries to appropriate locations
sudo mv -f /tmp/node_exporter /var/lib/node/

# Define the service unit file path
SERVICE_UNIT_FILE="/etc/systemd/system/node.service"

# Check if the service unit file already exists
if [ -e "$SERVICE_UNIT_FILE" ]; then
    echo "Service unit file $SERVICE_UNIT_FILE already exists."
    exit 1
fi

# Create the Prometheus service unit file
sudo tee "$SERVICE_UNIT_FILE" > /dev/null <<EOF
[Unit]
Description=Prometheus Node Exporter
Documentation=https://prometheus.io/docs/introduction/overview/
Wants=network-online.target
After=network-online.target

[Service]
Type=simple
User=prometheus
Group=prometheus
ExecReload=/bin/kill -HUP $MAINPID
ExecStart=/var/lib/node/node_exporter

SyslogIdentifier=prometheus_node_exporter
Restart=always

[Install]
WantedBy=multi-user.target
EOF

# Change ownership and permissions of Prometheus configuration and data directories
sudo chown -R prometheus:prometheus /var/lib/node
sudo chmod -R 775 /var/lib/node

# Reload systemd to apply the new unit file
sudo systemctl daemon-reload

# Start Prometheus service and enable it to start at boot
sudo systemctl start node
sudo systemctl enable node
