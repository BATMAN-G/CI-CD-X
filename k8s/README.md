# 🐳 Kubernetes Manifests for DEPI Project

This folder contains all Kubernetes manifests to deploy a **PHP web application** with a **MySQL database** on EKS (or any Kubernetes cluster).

✅ Fully declarative  
✅ Uses Secrets for credentials  
✅ External access via LoadBalancer  
✅ Ready for CI/CD integration (e.g., Jenkins)

---

## 📁 Included Files

| File | Purpose |
|------|---------|
| `mysql-deployment.yaml` | Deploys MySQL as a Deployment (with PVC for persistence) |
| `mysql-service.yaml` | Internal `ClusterIP` service for MySQL |
| `webapp-deployment.yaml` | Deploys the PHP web application (pulled from ECR) |
| `webapp-service.yaml` | External `LoadBalancer` service to expose the app |
| `ecr-secret.yaml` | Pull secret for Amazon ECR authentication |
| `mysql-creds.yaml` | Secret for MySQL root password |
| `webapp-creds.yaml` | Secret for DB connection (user, pass, host, etc.) |

> 💡 All manifests are namespaced under `default`. Modify `-n <namespace>` if needed.

---

## 🚀 Quick Deployment

### 1️⃣ Apply Secrets (⚠️ do this first!)
```bash
kubectl apply -f ecr-secret.yaml
kubectl apply -f mysql-creds.yaml
kubectl apply -f webapp-creds.yaml

2️⃣ Deploy MySQL
kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml

🔍 Wait until MySQL is ready:
kubectl get pods -l app=mysql --watch
# ✅ Expected: mysql-xxxxx   1/1   Running

3️⃣ Deploy Web Application
kubectl apply -f webapp-deployment.yaml
kubectl apply -f webapp-service.yaml

4️⃣ Get Public URL
# Try hostname first (common in EKS)
kubectl get svc webapp -o jsonpath='{.status.loadBalancer.ingress[0].hostname}'

# If empty, try IP
kubectl get svc webapp -o jsonpath='{.status.loadBalancer.ingress[0].ip}'
➡️ Open in browser: http://<RESULT>



