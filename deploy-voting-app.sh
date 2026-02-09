#!/bin/bash
# Deploy Voting App to EKS Cluster

set -e

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Load environment
export AWS_PROFILE=sysdig-trial
export KUBECONFIG="${SCRIPT_DIR}/kubeconfig"

echo "Deploying Voting App..."

# Apply all Kubernetes manifests
kubectl apply -f "${SCRIPT_DIR}/voting-app/k8s-specifications/"

echo ""
echo "Waiting for pods to start..."
sleep 15

echo ""
echo "Checking deployment status..."
kubectl get pods
kubectl get svc

echo ""
echo "Waiting for LoadBalancer external IPs..."
echo "This may take 2-3 minutes..."
sleep 30

echo ""
echo "=== Voting App Access URLs ==="
VOTE_URL=$(kubectl get svc vote -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
RESULT_URL=$(kubectl get svc result -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

if [ -z "$VOTE_URL" ]; then
    echo "Vote service is still provisioning. Check with: kubectl get svc vote"
else
    echo "Vote UI: http://$VOTE_URL:5000"
fi

if [ -z "$RESULT_URL" ]; then
    echo "Result service is still provisioning. Check with: kubectl get svc result"
else
    echo "Result UI: http://$RESULT_URL:5001"
fi

echo ""
echo "Run 'kubectl get svc' to check LoadBalancer status"
