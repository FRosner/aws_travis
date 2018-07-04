## Description

Example repository solving the chicken and egg problem when working with Terraform S3 remote state, where Terraform should provision its own state.
Disclaimer: This solution is not so easy to wrap your head around so I recommend to read the corresponding [blog post](https://dev.to/frosnerd/continuous-delivery-on-aws-with-terraform-and-travis-ci-3914).

Inspired by [Terraform Bootstrap example](https://github.com/monterail/terraform-bootstrap-example).

## Prerequisites

- [Terraform v0.11.7](https://www.terraform.io/intro/getting-started/install.html)
- [Jekyll 3.8.3](https://jekyllrb.com/docs/installation/)

## Usage

### Bootstrapping

```bash
# Create new workspace for bootstrapping
terraform workspace new state

# Initialize provider for bootstrapping
terraform init bootstrap

# Bootstrap state infrastructure
terraform apply -auto-approve bootstrap

# Fill in backend info (requires envsubst from package gettext)
source <(terraform output -state=terraform.tfstate.d/state/terraform.tfstate | tr -d " " | sed -e 's/^/export /')
envsubst '${BACKEND_BUCKET_NAME},${BACKEND_TABLE_NAME}' <backend/backend.tf.tmpl >backend/backend.tf

# Migrate state of remote backend to remote backend
terraform init backend
```

### Deploy Production Environment

```bash
# Create production environment workspace
terraform workspace new prod

# Init provider for website
terraform init website

# Build static site
cd website/static
jekyll build
cd -

# Deploy static site
terraform apply -auto-approve website
```

### Destroy Everything

```bash
# Destroy prod environment
terraform workspace select prod
terraform destroy -auto-approve website

# Migrate back to local statet
terraform init bootstrap

# Destroy remote state resources
terraform destroy bootstrap
```