# DevSecOps Security Pipeline

A practical **DevSecOps CI/CD security pipeline** for a Node.js web application, integrating automated security checks into the software delivery workflow.

The project demonstrates how application security can be integrated into CI/CD using **SAST, secret scanning, vulnerability scanning, IaC security scanning, Docker, Kubernetes, and Terraform**.

---

## 🛡️ Project Overview

This project implements a security-focused CI/CD workflow where source code and infrastructure are automatically assessed before deployment.

The pipeline integrates multiple security controls:

* **SAST** — SonarQube Cloud
* **Secret Detection** — Gitleaks
* **Filesystem Vulnerability Scanning** — Trivy
* **Infrastructure-as-Code Security** — Checkov
* **Containerization** — Docker
* **Orchestration** — Kubernetes
* **Infrastructure Provisioning** — Terraform
* **Periodic DAST** — OWASP ZAP (manual security testing)

The objective is to shift security testing earlier into the development lifecycle while maintaining a repeatable deployment process.

---

## 🏗️ Architecture

                    ┌──────────────────────┐
                    │    Developer / Git   │
                    └──────────┬───────────┘
                               │
                               ▼
                    ┌──────────────────────┐
                    │       GitHub         │
                    └──────────┬───────────┘
                               │
                               ▼
                  ┌──────────────────────────┐
                  │     GitHub Actions       │
                  │      DevSecOps CI/CD     │
                  └────────────┬─────────────┘
                               │
             ┌─────────────────┼─────────────────┐
             │                 │                 │
             ▼                 ▼                 ▼
       ┌───────────┐     ┌────────────┐    ┌────────────┐
       │ Gitleaks  │     │ SonarQube  │    │   Trivy    │
       │  Secrets  │     │ Cloud SAST │    │ Vulnerability│
       └───────────┘     └────────────┘    └────────────┘
                               │
                               ▼
                       ┌─────────────┐
                       │   Checkov   │
                       │ Terraform   │
                       │    IaC      │
                       └──────┬──────┘
                              │
                              ▼
                       ┌─────────────┐
                       │    Docker   │
                       │   Image     │
                       └──────┬──────┘
                              │
                              ▼
                       ┌─────────────┐
                       │ Kubernetes  │
                       │   Minikube  │
                       └──────┬──────┘
                              │
                              ▼
                       ┌─────────────┐
                       │ Node.js App │
                       └─────────────┘

             Periodic Manual Security Testing
                              │
                              ▼
                         OWASP ZAP
```

---

## 🔐 Security Pipeline

### 1. Gitleaks — Secret Detection
<img width="940" height="163" alt="image" src="https://github.com/user-attachments/assets/de821ccb-cc28-46e0-aa0a-361c0fdb3d8a" />


Gitleaks scans the repository for accidentally committed secrets such as:

* API keys
* Access tokens
* Credentials
* Private keys
* Other sensitive patterns

This helps prevent credentials from reaching the source-code repository.

---

### 2. SonarQube Cloud — SAST
<img width="940" height="371" alt="image" src="https://github.com/user-attachments/assets/5574f54a-80c7-4fde-8494-f2eaa5df81b0" />


SonarQube Cloud performs **Static Application Security Testing (SAST)** against the Node.js application.

It provides analysis for:

* Security vulnerabilities
* Bugs
* Code smells
* Maintainability issues
* Security hotspots

The project is configured to analyze the repository through GitHub Actions.

---

### 3. Trivy — Vulnerability Scanning

Trivy is used to identify vulnerabilities in the project filesystem and its dependencies.

The CI pipeline focuses on:

CRITICAL
HIGH severity vulnerabilities.

Findings are reviewed and assessed rather than automatically assuming that every reported vulnerability requires immediate remediation.

### 4. Checkov — Infrastructure Security
<img width="940" height="191" alt="image" src="https://github.com/user-attachments/assets/016a78cf-b0ce-4e38-9352-b8bccdab021d" />


Checkov performs security analysis of Infrastructure-as-Code.

The project contains Terraform configuration under:


terraform/


Checkov evaluates the Terraform configuration against security best practices and identifies potentially insecure configurations.

Example areas include:

* Network exposure
* Security group configuration
* Public access
* Infrastructure security controls
* Cloud configuration risks

---

## 🐳 Docker

The Node.js application is containerized using Docker.

Example image:

devsecops-node-app:latest
The Dockerized application provides a consistent runtime environment and can be deployed into Kubernetes.

---

## ☸️ Kubernetes Deployment
<img width="940" height="464" alt="image" src="https://github.com/user-attachments/assets/582eed4b-4654-430c-88de-f283984bee79" />


The application is deployed to a local Kubernetes cluster using **Minikube**.

The Kubernetes configuration is located under:

kubernetes/
├── deployment.yaml
└── service.yaml

The Deployment runs multiple application replicas:

```yaml
replicas: 2
The application is exposed using a Kubernetes `NodePort` service.

Example:

```text
NodePort: 30080
Application Port: 3000
```

The deployment was validated using:

```bash
kubectl get nodes
kubectl get pods
kubectl get services
```

The application was successfully accessed through the Minikube service.

---

## ☁️ Terraform

Terraform configuration is maintained under:

```text
terraform/
└── main.tf
```

The configuration demonstrates AWS infrastructure provisioning concepts including:

* AWS provider configuration
* S3 bucket
* Security group
* Network access rules

The Terraform configuration is also analyzed using Checkov as part of the security workflow.

---

## 🧪 Manual DAST — OWASP ZAP

OWASP ZAP is used separately for **periodic manual Dynamic Application Security Testing (DAST)**.

It is not currently executed automatically in the GitHub Actions workflow.

The manual testing process can be used to identify issues such as:

* Injection vulnerabilities
* Authentication issues
* Security misconfigurations
* Missing security headers
* XSS
* Other runtime web application vulnerabilities

Periodic ZAP testing complements the automated CI security controls.

---

## 🔄 GitHub Actions Workflow

The CI workflow is located at:

```text
.github/workflows/devsecops.yaml
```

Pipeline flow:

Git Push / Pull Request
        │
        ▼
   GitHub Actions
        │
        ├── Gitleaks
        │
        ├── SonarQube Cloud
        │
        ├── Trivy
        │
        └── Checkov


The workflow is triggered on:

```yaml
push:
  branches:
    - main

pull_request:
  branches:
    - main
```

---

## 📁 Project Structure

```text
devsecops-security-pipeline/
│
├── .github/
│   └── workflows/
│       └── devsecops.yaml
│
├── app/
│   ├── package.json
│   ├── package-lock.json
│   ├── server.js
│   └── sonar-project.properties
│
├── kubernetes/
│   ├── deployment.yaml
│   └── service.yaml
│
├── terraform/
│   └── main.tf
│
├── Dockerfile
│
└── .gitignore
```

---

## ⚙️ Technologies Used

| Category                | Technology      |
| ----------------------- | --------------- |
| Application             | Node.js         |
| Version Control         | Git / GitHub    |
| CI/CD                   | GitHub Actions  |
| SAST                    | SonarQube Cloud |
| Secret Scanning         | Gitleaks        |
| Vulnerability Scanning  | Trivy           |
| IaC Security            | Checkov         |
| Containerization        | Docker          |
| Container Orchestration | Kubernetes      |
| Local Kubernetes        | Minikube        |
| IaC                     | Terraform       |
| DAST                    | OWASP ZAP       |
| Cloud                   | AWS             |

---

## 🚀 Running the Application Locally

Navigate to the application directory:

```bash
cd app
```

Install dependencies:

```bash
npm install
```

Start the application:

```bash
node server.js
```

The application can then be accessed locally through its configured port.

---

## 🐳 Building the Docker Image

From the project root:

```bash
docker build -t devsecops-node-app:latest .
```

Run the container:

```bash
docker run -p 3000:3000 devsecops-node-app:latest
```

---

## ☸️ Deploying to Minikube

Start Minikube:

```bash
minikube start --driver=docker
```

Load the Docker image:

```bash
minikube image load devsecops-node-app:latest
```

Deploy the application:

```bash
kubectl apply -f kubernetes/deployment.yaml
```

Create the service:

```bash
kubectl apply -f kubernetes/service.yaml
```

Verify the deployment:

```bash
kubectl get pods
kubectl get services
```

Access the application:

```bash
minikube service devsecops-node-app-service
```

---

## 🔑 GitHub Secrets

The GitHub Actions workflow uses a repository secret for SonarQube Cloud authentication.

Required secret:

```text
SONAR_TOKEN
```

The token is stored securely in:

```text
GitHub Repository
→ Settings
→ Secrets and variables
→ Actions
```

No credentials or security tokens are stored in the source code.

---

## 📊 Security Approach

This project follows a **shift-left security** approach.

Security controls are introduced at different stages:

```text
Source Code
    │
    ├── Secret Detection
    │
    ├── SAST
    │
    ├── Vulnerability Scanning
    │
    ├── IaC Security
    │
    ▼
Containerization
    │
    ▼
Kubernetes Deployment
    │
    ▼
Periodic Manual DAST
```

This approach helps identify security issues earlier while reducing the risk of insecure code and infrastructure progressing toward deployment.

---

## 🎯 Key Learning Outcomes

Through this project, I implemented and worked with:

* DevSecOps pipeline design
* CI/CD security integration
* Static Application Security Testing
* Secret detection
* Vulnerability management
* Infrastructure-as-Code security
* Docker containerization
* Kubernetes deployment
* Terraform infrastructure
* GitHub Actions automation
* Security findings triage
* Manual web application security testing

---

## 🔮 Future Improvements

Potential enhancements include:

* Container image scanning with Trivy inside CI
* Kubernetes manifest scanning with Checkov
* Kubernetes security hardening
* Runtime container security monitoring
* Automated security gates for critical findings
* SBOM generation
* Artifact signing and verification
* Deployment to AWS EKS
* Centralized security monitoring with a SIEM
* Automated DAST integration where appropriate

---

## 👨‍💻 Author
**Naveen Kumar**



This project is intended for **educational, portfolio, and authorized security testing purposes**. Security testing should only be performed against systems and applications for which appropriate authorization has been obtained.
