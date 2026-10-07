\# Monitoring and Alerting



\## Overview



The platform uses Amazon CloudWatch for application logs, ECS metrics,

Application Load Balancer metrics, and operational alarms.



Amazon SNS provides the notification destination for CloudWatch alarms.

The repository creates the SNS topic but deliberately does not hard-code

an email address or third-party notification endpoint.



\## Application Logs



The FastAPI application writes logs to stdout/stderr.



ECS uses the `awslogs` log driver to send container logs to:



`/ecs/finzla-cloud-platform-<environment>`



The CloudWatch log group has a retention period of 30 days.



No application secrets should be written to logs.



\## Metrics



The platform monitors:



\- ALB `UnHealthyHostCount`

\- ALB `HTTPCode\_Target\_5XX\_Count`

\- ALB `TargetResponseTime`

\- ECS `CPUUtilization`

\- ECS `MemoryUtilization`



ECS Container Insights is also enabled on the cluster for additional

runtime visibility.



\## Alerts



\### Unhealthy ALB Targets



Trigger:



At least one target remains unhealthy for two consecutive one-minute

evaluation periods.



Why it matters:



An unhealthy target can indicate application startup failure, an incorrect

health-check path or port, security-group problems, or an unhealthy ECS task.



Notification:



The CloudWatch alarm publishes to the platform SNS alerts topic. In a

production environment this topic would be connected to the approved

operations/on-call notification system.



First investigation:



1\. Check the ALB target group's target-health status and reason codes.

2\. Check ECS service events and running task status.

3\. Review application logs in CloudWatch.

4\. Verify the target-group health-check path and container port.

5\. Verify the ALB-to-ECS security-group path.



\### Application 5xx Errors



Trigger:



At least five target-generated HTTP 5xx responses in each of two

consecutive one-minute evaluation periods.



Why it matters:



Repeated 5xx responses indicate that requests are reaching the application

but the application is failing to process them successfully.



Notification:



The CloudWatch alarm publishes to the platform SNS alerts topic.



First investigation:



1\. Review application logs around the alarm time.

2\. Check recent application deployments and task-definition revisions.

3\. Check ECS task health and resource utilization.

4\. Correlate failures with ALB latency, CPU, and memory metrics.



\## Additional Resource Alarms



CPU and memory alarms trigger when average ECS service utilization remains

at or above 80 percent for two consecutive five-minute periods.



The latency alarm triggers when average ALB target response time remains

above two seconds for two consecutive five-minute periods.



These thresholds are initial operational defaults. Production thresholds

should be tuned using observed workload behaviour, service-level objectives,

traffic volume, and acceptable error rates.

