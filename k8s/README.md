# k8s deployment

## VPC

secrets
```console
ln -s secret.tf vpc/secret.tf
```

Enter the `vpc` directory 
```console
terraform init
terraform plan -out vpc.retry
terraform apply "vpc.retry"
```

Copy the output `k8s_vpc = vpc-xxxXXXXxxxxXX` in `variables.tf` where `vpc_id` variable is defined
```terraform
variable "vpc_id" {
  description = "ID for VPC"
  default     = "vpc-xxxXXXXxxxxXX"
}
```
