# Sysdig Security Assessment

Technical assessment demonstrating Sysdig Secure and Monitor capabilities with a cloud-native voting application deployed on AWS EKS.

## Architecture

- **Cloud Provider:** AWS EKS
- **Region:** us-east-1
- **Cluster:** sysdig-cluster (1x t3.xlarge node)
- **Application:** Example Voting App (5 microservices)
- **Monitoring Agent:** Sysdig Deploy (comprehensive)

## Project Structure

```
sysdig-assessment/
├── .github/workflows/          # CI/CD pipelines
│   └── sysdig-scan.yml        # Container scanning workflow
├── terraform/                 # Infrastructure as code
│   ├── aws-integration/       # Sysdig AWS account integration
│   │   └── main.tf
│   └── eks-cluster/          # EKS cluster infrastructure
│       ├── provider.tf
│       ├── variables.tf
│       ├── eks-cluster.tf
│       ├── eks-nodes.tf
│       ├── vpc.tf
│       └── outputs.tf
├── voting-app/               # Application code and manifests
│   ├── vote/                 # Python voting frontend
│   ├── result/               # Node.js results frontend
│   ├── worker/               # .NET vote processor
│   └── k8s-specifications/   # Kubernetes manifests
├── deploy-voting-app.sh      # Application deployment
├── install-sysdig-deploy.sh  # Agent installation
└── generate-security-events.sh # Security testing
```

## Application Components

The voting application consists of 5 microservices:

- **vote** - Python web frontend for casting votes
- **result** - Node.js web frontend for viewing results
- **worker** - .NET worker processing votes
- **db** - PostgreSQL database
- **redis** - Redis cache

## Deployment

### 1. Deploy Infrastructure

```bash
cd terraform/eks-cluster
terraform init
terraform apply
```

### 2. Configure kubectl

```bash
aws eks update-kubeconfig --region us-east-1 --name sysdig-cluster
```

### 3. Install Sysdig Agent

```bash
./install-sysdig-deploy.sh
```

Wait 5-10 minutes for agent to connect and start reporting.

### 4. Deploy Application

```bash
./deploy-voting-app.sh
```

### 5. Verify Deployment

```bash
kubectl get pods -n default
kubectl get svc -n default
```

Access the application via LoadBalancer external IPs.

## Sysdig Features Implemented

### Secure
- ✅ **Vulnerability Scanning** - Runtime image analysis
- ✅ **Compliance Benchmarks** - CIS Kubernetes, NSA/CISA
- ✅ **Runtime Threat Detection** - Process and file monitoring
- ✅ **Activity Audit** - kubectl command tracking
- ✅ **CI/CD Scanning** - GitHub Actions integration

### Monitor
- ✅ **Advisor** - Resource optimization recommendations
- ✅ **Cost Analysis** - Spend visibility and savings opportunities
- ✅ **PromQL Queries** - Custom metric queries
- ✅ **Performance Dashboards** - Real-time monitoring

## GitHub Actions - Container Scanning

The CI/CD pipeline automatically scans container images on every push:

**Setup:**
1. Add `SYSDIG_SECURE_TOKEN` to repository secrets
2. Push changes to trigger workflow
3. View scan results in Security tab

**What it does:**
- Builds vote, result, and worker containers
- Scans with Sysdig CLI scanner
- Reports vulnerabilities (Medium severity and above)
- Uploads SARIF results to GitHub Security
- Runs in parallel for fast feedback

## Key Findings

### Security
- Identified container images with critical vulnerabilities
- Analyzed risk based on CVSS scores and exploitability
- Demonstrated runtime threat detection capabilities
- Configured compliance scanning for CIS benchmarks

### Operations
- Discovered resource over-provisioning opportunities
- Quantified potential cost savings
- Built custom monitoring queries
- Demonstrated forensic investigation features

## Cleanup

```bash
# Delete application
kubectl delete -f voting-app/k8s-specifications/

# Uninstall Sysdig agent
helm uninstall sysdig-agent -n sysdig-agent

# Destroy infrastructure
cd terraform/eks-cluster
terraform destroy
```

## Notes

- All secrets managed via environment variables
- Infrastructure as code for reproducibility
- Documentation stored separately for security
- GitOps-ready configuration

---

**Sysdig Solutions Engineer Technical Assessment**
Demonstrating cloud-native security and observability best practices
