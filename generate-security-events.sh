#!/bin/bash
# Script to Generate Sysdig Security Events

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export KUBECONFIG="${SCRIPT_DIR}/kubeconfig"

echo "=== Generating Security Events for Sysdig Demo ==="
echo ""

# Get vote pod name
VOTE_POD=$(kubectl get pod -l app=vote -o jsonpath='{.items[0].metadata.name}')
echo "Using pod: $VOTE_POD"
echo ""

echo "Event 1: Suspicious Shell Access & Reconnaissance"
kubectl exec -it $VOTE_POD -- sh -c "whoami && hostname && cat /etc/passwd | head -5"
echo ""

echo "Event 2: Attempting to Read Sensitive Files"
kubectl exec -it $VOTE_POD -- sh -c "cat /etc/shadow 2>&1 || echo 'Access denied (expected)'"
echo ""

echo "Event 3: Network Reconnaissance"
kubectl exec -it $VOTE_POD -- sh -c "nc -zv -w 2 google.com 443 2>&1 || echo 'Connection attempt logged'"
echo ""

echo "Event 4: Suspicious File Creation"
kubectl exec -it $VOTE_POD -- sh -c "touch /tmp/suspicious-file && echo 'malicious' > /tmp/suspicious-file"
echo ""

echo "Event 5: Attempting Package Installation (Potential Malware)"
kubectl exec -it $VOTE_POD -- sh -c "apk add --no-cache wget 2>&1 || echo 'Package install attempted'"
echo ""

echo "=== Events Generated! ==="
echo "Check Sysdig Portal: https://app.us4.sysdig.com"
echo "Go to: Events > Security Events or Threats"
echo "Filter by: Last 1 hour"
