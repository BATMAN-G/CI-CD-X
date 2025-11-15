# 🐳 Kubernetes Manifests for DEPI Project

This folder contains all Kubernetes deployment files for the PHP web application with MySQL database.

## 📁 Files Included

- `mysql-pvc.yaml` → Persistent Volume Claim for MySQL data
- `mysql-deployment.yaml` → MySQL server deployment
- `mysql-service.yaml` → Service to expose MySQL internally
- `webapp-deployment.yaml` → Web application deployment
- `webapp-service.yaml` → Service to expose web app externally
- `01-init.sql`, `init.sql` → Database initialization scripts
- `secrets.example.yaml` → Template for database credentials (⚠️ DO NOT USE DIRECTLY — edit values first!)

## 🛠 How to Deploy

1. Apply PVC first:
   ```bash
   kubectl apply -f mysql-pvc.yaml
2. kubectl apply -f secrets.example.yaml
3. kubectl apply -f mysql-deployment.yaml
kubectl apply -f mysql-service.yaml
kubectl apply -f webapp-deployment.yaml
kubectl apply -f webapp-service.yaml
4. minikube service webapp-service --url

