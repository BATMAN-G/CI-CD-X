# 🐳 Kubernetes Manifests for DEPI Project

This folder contains all Kubernetes deployment files for the PHP web application with MySQL database.

## 📁 Files Included

- `mysql-deployment.yaml` → MySQL server deployment
- `mysql-service.yaml` → Service to expose MySQL internally
- `webapp-deployment.yaml` → Web application deployment
- `webapp-service.yaml` → Service to expose web app externally

## 🛠 How to Deploy

1. Apply Secrets
kubectl apply -f ecr-secret.yaml
kubectl apply -f mysql-creds.yaml
kubectl apply -f webapp-creds.yaml

2. Deploy MySQL
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml

Wait for MySQL pod to be ready:
kubectl get pods -l app=mysql --watch

3. Deploy Web Application
kubectl apply -f webapp-deployment.yaml
kubectl apply -f webapp-service.yaml

4. Get LoadBalancer URL
kubectl get svc -n default -o jsonpath='{.items[?(@.spec.type=="LoadBalancer")].status.loadBalancer.ingress[0].hostname}'

❗ Troubleshooting
Pods stuck in Pending state?
Check if PVC is bound: kubectl get pvc
Check node resources: kubectl describe nodes

Webapp can’t connect to MySQL?
Verify MYSQL_HOST matches the service name (usually mysql).
Check secret values: kubectl get secret webapp-creds -o yaml

LoadBalancer External IP never appears?
Wait 5-10 minutes — ELB creation takes time.
Check VPC/Subnet settings — must be tagged for EKS load balancers.

Jenkins pipeline fails?
Check logs for kubectl apply errors.
Validate AWS credentials and IAM roles.
Confirm file paths (e.g., k8s/ folder exists).

