\# Engineering Decisions



\## 1. Architecture Choice



\### Selected Platform: Amazon ECS on AWS Fargate



The application is deployed using Amazon ECS with the Fargate launch type.



The architecture consists of:



\- Application Load Balancer in public subnets

\- ECS/Fargate tasks in private subnets

\- Amazon ECR for container images

\- CloudWatch Logs and metrics for observability

\- IAM roles for workload and deployment identities

\- GitHub Actions with AWS OIDC authentication

\- Terraform for infrastructure as code



Request path:



Internet -> HTTPS ALB -> Target Group -> ECS/Fargate -> FastAPI



The application tasks do not receive public IP addresses and cannot be

accessed directly from the Internet.



\### Why ECS/Fargate



ECS/Fargate was selected because the workload is a small containerized web

service and does not require Kubernetes-specific functionality.



Fargate removes the need to provision, patch, scale, and maintain EC2 worker

nodes while still providing container orchestration, health management,

service deployment, IAM integration, and CloudWatch integration.



This keeps the platform small enough to understand and operate while meeting

the assessment requirements.



\### Alternative Considered: Amazon EKS



Amazon EKS was considered as an alternative.



EKS would provide Kubernetes APIs, a large ecosystem, and greater portability

for organizations already standardized on Kubernetes.



It was not selected because this application does not currently require the

additional operational complexity of Kubernetes. EKS would introduce more

components, configuration, security considerations, and operational overhead

without providing a material benefit for this workload.



If the platform later needed Kubernetes-native tooling, complex multi-service

orchestration, or organizational Kubernetes standardization, EKS could become

a stronger option.



\---



\## 2. Reliability and Failed Deployments



The ECS service uses an Application Load Balancer health check against:



`/health`



A task is only considered healthy by the load balancer when the endpoint

returns the expected HTTP 200 response.



The ECS service also enables the deployment circuit breaker:



```hcl

deployment\_circuit\_breaker {

&#x20; enable   = true

&#x20; rollback = true

}

