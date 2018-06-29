Inspired by [Terraform Bootstrap example](https://github.com/monterail/terraform-bootstrap-example).

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
```