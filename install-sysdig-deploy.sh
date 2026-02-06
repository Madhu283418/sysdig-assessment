#!/bin/bash
# Install Sysdig Deploy Chart (Comprehensive Installation)

export KUBECONFIG=/path/to/repo/kubeconfig

echo "=== Installing Sysdig Deploy (Comprehensive Agent) ==="
echo ""

# Add/update repo
helm repo add sysdig https://charts.sysdig.com
helm repo update

# Install sysdig-deploy with all features
helm install sysdig-agent --namespace sysdig-agent --create-namespace \
    --set global.sysdig.accessKey=69bfeec7-7ed6-498f-a184-67f6341916dd \
    --set global.sysdig.region=us4 \
    --set global.clusterConfig.name=sysdig-cluster \
    --set nodeAnalyzer.secure.vulnerabilityManagement.newEngineOnly=true \
    --set global.kspm.deploy=true \
    --set nodeAnalyzer.nodeAnalyzer.benchmarkRunner.deploy=true \
    --set agent.sysdig.settings.feature.mode=secure \
    --set agent.sysdig.settings.feature.monitoring=false \
    sysdig/sysdig-deploy

echo ""
echo "=== Installation Complete ==="
echo ""
echo "Verify installation:"
echo "kubectl get pods -n sysdig-agent"
echo ""
echo "This installs:"
echo "- Runtime threat detection"
echo "- Vulnerability scanning"
echo "- KSPM (compliance scanning)"
echo "- Benchmark runner (CIS benchmarks)"
echo "- Node analyzer"
