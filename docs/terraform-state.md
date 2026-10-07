\# Terraform State Management



\## Remote State



The platform is designed to use an Amazon S3 remote backend rather than

storing shared Terraform state on a developer workstation.



The backend uses S3 native state locking:



```hcl

terraform {

&#x20; backend "s3" {

&#x20;   encrypt      = true

&#x20;   use\_lockfile = true

&#x20; }

}



\## Backend-specific values are supplied during initialization rather than

hard-coded into the root Terraform configuration.

Development:



terraform -chdir=terraform init \\

&#x20; -backend-config=backend/dev.hcl



Production:



terraform -chdir=terraform init \\

&#x20; -backend-config=backend/prod.hcl

\## Environment Isolation

Development and production use separate state objects:



finzla-cloud-platform/dev/terraform.tfstate

finzla-cloud-platform/prod/terraform.tfstate



They also use separate Terraform variable files:



environments/dev.tfvars

environments/prod.tfvars



This reduces the risk of a development operation accidentally modifying

production state.

For stronger production isolation, separate AWS accounts should be considered.

\## State Locking

The S3 backend uses Terraform's S3 lockfile support.

When one Terraform operation holds the state lock, another operation targeting

the same state should not modify that state concurrently.

This protects against concurrent operations corrupting or overwriting state.

Older Terraform S3 backend implementations commonly used DynamoDB for state

locking. DynamoDB-based locking is deprecated in current Terraform versions,

so this project uses the S3 lockfile mechanism for new configuration.

\## Backend Bootstrap

The remote backend cannot create the S3 bucket that it requires in order to

initialize.

The backend therefore requires a one-time bootstrap step before the main

Terraform configuration is used.

The backend S3 bucket should be configured with:

\- versioning enabled;

\- server-side encryption;

\- all public access blocked;

\- least-privilege IAM access;

\- state locking enabled through the S3 backend lockfile;

\- appropriate lifecycle and recovery controls.

The backend bucket should not contain application data.

No backend infrastructure is provisioned as part of this assessment because

live AWS deployment is intentionally not being performed.

\## State Security

Terraform state can contain infrastructure metadata and potentially sensitive

values.

Access to the backend should therefore be restricted to authorized

infrastructure identities.

The state bucket should:

\- reject public access;

\- require encrypted transport;

\- use encryption at rest;

\- have versioning enabled;

\- restrict read/write/delete permissions;

\- log or audit administrative access where appropriate.

Secrets should not be deliberately stored directly in Terraform configuration

or committed .tfvars files.

Sensitive application secrets should instead come from an approved secret

management service such as AWS Secrets Manager or Systems Manager Parameter

Store.

\## CI/CD Concurrency

Terraform state locking protects the state itself, while CI/CD concurrency

controls should also prevent multiple infrastructure deployments for the same

environment from running simultaneously.

Development and production should use separate deployment concurrency groups.

Production should additionally use protected environments and approval gates

before infrastructure changes are applied.

