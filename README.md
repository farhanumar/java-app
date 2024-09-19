# Docker image - helm chart - service expose 

Prereqs:

- [X] docker is installed
- [X] helm and kubectl are installed
- [X] k8s is setup
- [X] nginx ingress controller is installed
- [X] cert-manager is installed

> [!Note]
> helm chart location: helm/digitify]

Makefile has been created to with following targets:

```
Targets:
help                 Show this help message
docker-build         Build the Docker image without cache
docker-run           Run the Docker container on port 8080
docker-tag           Tag the Docker image for the repository
docker-push          Push the Docker image to the repository
docker-build-push    Build, tag, and push the Docker image
install-k3s          Install k3s
install-helm-chart   Install or upgrade the Helm chart
uninstall-helm-chart Uninstall the Helm release
port-forward         Forward port 8000 to 8080 for digitify service
setup-ingress-cert   Installs nginx ingress controller and cert manager using helm
```
To build and push with `fan0o/digitify:latest` tag:

    make docker-build-push

To install helm chart in namespace `digitify` with release name `digitify`:

    make install-helm-chart

To expose kubernetes service on port `8080` 

    make port-forward 

You can access the service on <url>http://127.0.0.1:8080</url>

# terraform Provisioing vpc and eks

Prereqs:

- [X] terraform is installed
- [X] AWS Credentials are configured

> [!Note]
> - terraform code location: terraform]
> - dev.tfvars contain all the variables
> - aws credentials are generated using console
> - awscli is install and credentials are set using aws config

Terraform code consists of two modules in `terraform/module`

  - vpc
  - eks

main.tf calls both of the module and create following infrastructure such as 

  - VPC, private and public subnets, NAT and Internet Gateway, routes
  - EKS cluster (cluster endpoint exposed publicly), eks managed node group 

To initiate terraform plan:

    terraform init

To run terraform plan

    terraform plan -var-file=dev.tfvars

To apply the plan

    terraform apply -var-file=dev.tfvars

# Github actions for building image, deploy infra and installing helm chart:

Prereqs:

- [X] Github app is installed
- [X] Github OIDC setup in AWS IAM Console as explain [here](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)
- [x] AWS Secrets are stored in Github actions Secret
- [X] Github App ID and Private key are setup in Secrets and Variables

Building docker image workflow `digitify image build`:

 - Run on push / pull request to main branch
 - Checks out repo with github app pem key and app-id
 - Has condition not to run if context id matches or commit message matches `#ignore-build`
 - Uses Github app to build image
 - Build the image with short sha tag (7 characters)
 - Uses Github OIDC and assumes IAM role to configure ECR repo digitify
 - Pushed the image to ECR Repo in us-west-2 region
 - Creates a PR to update the image tag in values file (Deploys the helm chart upon merge)

Deploy infrastructure:

 - Run on any changes push to terraform directory
 - Configures the AWS access for github actions
 - Sets up terraform
 - Run the terraform init, plan and apply commands

Helm deployment:

 - Run on push to main branch with values files `helm/digitify/values.yaml` changes
 - Installs awscliv2, kubectl and helm
 - Configures the aws credentials using Secrets stored in Github action Secrets
 - Tests the connection
 - Installs the helm chart.