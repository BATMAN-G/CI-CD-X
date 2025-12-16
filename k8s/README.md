# 🐳 Kubernetes Manifests for DEPI Project

This folder contains all Kubernetes deployment files for the PHP web application with MySQL database.

## 📁 Files Included

- `mysql-deployment.yaml` → MySQL server deployment
- `mysql-service.yaml` → Service to expose MySQL internally
- `webapp-deployment.yaml` → Web application deployment
- `webapp-service.yaml` → Service to expose web app externally

## 🛠 How to Deploy

1. kubectl apply -f mysql-deployment.yaml
2. kubectl apply -f mysql-service.yaml
3. kubectl apply -f webapp-deployment.yaml
4. kubectl apply -f webapp-service.yaml
5. minikube service webapp-service --url

