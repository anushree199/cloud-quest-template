# Cloud Quest Deployment
#C:\Program Files\nodejs\
## Requirements Completed
- ✅ Dockerized Node.js app (multi-stage build)
- ✅ Hosted in AWS ECS Fargate with Load Balancer (HTTP)
- ✅ SECRET_WORD injected as env var
- ✅ Infrastructure managed using Terraform

## How to Deploy
1. Build and push Docker image to ECR.
2. Set `terraform.tfvars` with correct ECR image URI and secret word.
3. Run `terraform init && terraform apply`.

## Given more time, I would improve...
- Add HTTPS using self-signed or ACM certs.
- Use a CI/CD pipeline to automate builds and deploys.
- Add monitoring and better error handling for bin scripts.
