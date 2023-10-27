# gke-enterprise-demo

1. Create a GCP project and enable billing (e.g. gke-enterprise-demo-1234)
2. Create GCS bucket to store the terraform state (e.g. gke-enterprise-demo-1234_tfstate)
3. Update the backend in `main.tf` to use the bucket you created
4. Create your tfvars file:
```cp terraform.tfvars.example terraform.tfvars```
5. Edit terraform.tfvars and update `project_id` variable with your project id
6. Run `terraform -chdir=./terraform init`
7. Run `terraform -chdir=./terraform apply`
8. Review the plan, then type `yes` to execute
