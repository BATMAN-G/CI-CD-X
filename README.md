# CI-CD-X: End-to-End DevOps Pipeline on AWS

Infrastructure

<img width="1512" height="917" alt="Screenshot 2026-01-02 185027" src="https://github.com/user-attachments/assets/56af7974-f08f-42c6-8d61-9fc48597ac24" />

A fully automated DevOps pipeline deploying a secure PHP-MySQL web application on **Amazon EKS**, built using industry-standard tools: **AWS**, **Terraform**, **Jenkins**, **Kubernetes**, **Docker**, and **Ansible**.

✅ Infrastructure as Code (Terraform)  
✅ Secure CI/CD (Jenkins → Nexus → EKS)  
✅ Private Container Registry (Nexus on Docker)  
✅ Persistent Data with PVCs (No EBS CSI — custom local storage class)  
✅ Production-ready: Secrets, initContainers, resource limits, health checks  

---

## 🌐 Overview
This project demonstrates a real-world DevOps workflow:
1. **Bootstrap**: Ansible for pre-deployment config.
2. **Infra**: Terraform provisions VPC, EKS cluster (`Depii-cluster`), node groups (AL2023), and IAM roles.
3. **Build**: Jenkins builds Docker images (PHP app + MySQL) on push to `main`.
4. **Store**: Images pushed to self-hosted Nexus registry (HTTPS-enabled).
5. **Deploy**: Jenkins applies K8s manifests — with PVCs, Secrets, and dependency-aware startup (`wait-for-mysql` initContainer).
6. **Serve**: PHP frontend (dark-themed HTML) + MySQL backend deployed on EKS with `LoadBalancer`.

No domain? No problem — works over IP with TLS-aware image pulling and secure credential handling.

---

## 🛠️ Tech Stack
| Layer | Tools |
|-------|-------|
| **Cloud** | AWS (EKS, EC2, VPC, IAM) |
| **IaC** | Terraform |
| **CI/CD** | Jenkins, Nexus |
| **Orchestration** | Kubernetes (Deployments, Services, PVCs, Secrets) |
| **Containers** | Docker |
| **Config Mgmt** | Ansible |
| **App** | PHP (PDO, password_hash), MySQL 8.0, static HTML (dark theme) |

---

## 🚀 Quick Start
```bash
# Provision infra
cd terraform && terraform apply

# Run pipeline
# Push to main → Jenkins triggers → App live on EKS!

# Local dev
minikube start && kubectl apply -k k8s/
minikube service php-app-service# CI-CD-X
