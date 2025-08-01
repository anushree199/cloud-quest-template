# Cloud Quest Deployment – Rearc Assessment

This project is a cloud-native deployment of the Cloud Quest application, containerized with Docker and deployed to **AWS ECS (Fargate)** using **Terraform**. The app is accessible over both HTTP and HTTPS, using **self-signed TLS certificates** mounted into the container at runtime.

## Overview

The objective of this project was to complete the Rearc Cloud Quest challenge by:

- Containerizing a Node.js and Go-based web application
- Deploying it to a public cloud (AWS)
- Making it publicly accessible over HTTP and HTTPS
- Using Infrastructure as Code (Terraform) to manage resources
- Passing TLS, load balancer, and Docker-based validation endpoints

---

## Key Technologies Used

- **AWS ECS Fargate** – Fully managed container orchestration
- **Terraform** – Infrastructure as Code for ECS tasks, services, networking
- **Docker** – Containerization of the application
- **Self-signed TLS certs** – For HTTPS support on port 3443
- **ALB (Application Load Balancer)** – Planned for HTTPS, but skipped due to domain requirements

---

## Architecture Summary

- ECS Fargate cluster and task definition
- Task launched in a private subnet with a public IP
- App listens on ports **3000 (HTTP)** and **3443 (HTTPS)**
- TLS certificate files mounted into the container at runtime
- Security groups configured to allow external access
- ALB resource exists in Terraform but is commented out or fails without a domain

---

## TLS and HTTPS – Self-signed Certificates

This project uses **self-signed TLS certificates**, which browsers mark as “Not Secure” since they are not issued by a public CA. This is acceptable per the Cloud Quest guidelines:

> "You may use locally-generated certs."

### How TLS was implemented

1. Certificates were generated locally using OpenSSL:

   ```bash
   openssl req -x509 -newkey rsa:4096 -nodes -keyout cert/key.pem -out cert/cert.pem -days 365
````

2. Certificates are **mounted into the container** using ECS task volume definitions.

3. The Node.js application listens on port 3443 and loads certs from `/app/cert`.

4. HTTPS is accessed via:

   ```
   https://<public-ip>:3443/tls
   ```

Browser will show a certificate warning. You can safely proceed.

---

## Why ALB TLS (ACM) Was Not Used

Terraform includes configuration to create an HTTPS listener on AWS ALB using ACM, but this was intentionally skipped due to:

* ACM requires a **fully-qualified domain name (FQDN)**
* Domain ownership verification must be completed via DNS or email
* Free domain options were either unavailable or unreliable
* Resulting error:

  ```
  UnsupportedCertificate: The certificate must have a fully-qualified domain name, a supported signature, and a supported key size.
  ```

Using self-signed certificates allowed us to fulfill the TLS stage without incurring any cost or dependency on domains.

---

## How to Run This Project

### 1. Generate Certificates (if not done yet)

```bash
mkdir cert
openssl req -x509 -newkey rsa:4096 -nodes -keyout cert/key.pem -out cert/cert.pem -days 365
```

### 2. Build Docker Image

```bash
docker build -t quest-app .
```

### 3. Push to ECR (Assumes ECR repo already created)

```bash
aws ecr get-login-password | docker login --username AWS --password-stdin <your-account-id>.dkr.ecr.<region>.amazonaws.com
docker tag quest-app <your-ecr-repo-uri>
docker push <your-ecr-repo-uri>
```

### 4. Deploy with Terraform

```bash
cd terraform/
terraform init
terraform apply
```

Terraform provisions:

* VPC, subnets, security groups
* ECS cluster, task definition, service
* IAM roles for Fargate
* (Optionally) ALB resources (commented out or skipped)

---

## Test URLs

After deployment, access the following:

* App index page: `https://<public-ip>:3443/`
* TLS validation: `https://<public-ip>:3443/tls`
* Docker check: `https://<public-ip>:3443/docker`
* Load balancing check: `https://<public-ip>:3443/loadbalanced`
* Secret word: `https://<public-ip>:3443/secret_word`

Replace `<public-ip>` with your Fargate task’s public IP or ALB DNS name (if used).

---

## Given More Time, I Would Improve...

* Set up a free or low-cost domain and complete ACM validation
* Enable full HTTPS through ALB + ACM integration
* Automate builds and deployments using GitLab CI/CD or GitHub Actions
* Implement centralized logging and health checks in ECS
* Add EFS for secret/cert mounting instead of container volume

---

## Notes for Reviewers

* HTTPS is implemented with a self-signed cert mounted into the ECS Fargate task
* ALB with HTTPS via ACM is defined but fails without a domain, so is excluded
* All app routes work as expected via HTTP and HTTPS
* Terraform code is modular and well-structured for infrastructure setup

```

