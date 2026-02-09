#!/bin/bash
# Sysdig Agent Installation Script
# Generated from Sysdig Portal

set -e

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment
export AWS_PROFILE=sysdig-trial
export KUBECONFIG="${SCRIPT_DIR}/kubeconfig"

echo "Installing Sysdig Shield Agent..."

# Add Sysdig Helm repo
helm repo add sysdig https://charts.sysdig.com
helm repo update

# Install Sysdig Shield with all features
helm install shield --namespace sysdig --create-namespace \
    --set cluster_config.name=sysdig-cluster \
    --set sysdig_endpoint.region=us4 \
    --set sysdig_endpoint.access_key=69bfeec7-7ed6-498f-a184-67f6341916dd \
    --set features.posture.cluster_posture.enabled=true \
    --set features.posture.host_posture.enabled=true \
    --set features.vulnerability_management.container_vulnerability_management.enabled=true \
    --set features.vulnerability_management.host_vulnerability_management.enabled=true \
    sysdig/shield

echo ""
echo "Waiting for Sysdig pods to start..."
sleep 10

echo ""
echo "Checking Sysdig agent status..."
kubectl get pods -n sysdig

echo ""
echo "Installation complete! Verify in Sysdig portal at https://app.us4.sysdig.com"
