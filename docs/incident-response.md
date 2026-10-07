\# Incident Response Runbook



\## Scenario



A deployment reports success and ECS tasks are running, but customers receive

HTTP 503 responses and the Application Load Balancer reports unhealthy targets.



The objective is to determine whether the failure is caused by the application,

ECS configuration, load balancer configuration, or network controls, and then

restore service using the lowest-risk recovery action.



\---



\## 1. Confirm the Customer-Facing Symptom



First confirm that the problem is reproducible from outside the AWS environment.



```bash

curl -i https://<application-domain>/health

