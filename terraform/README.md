# Using Terraform to deploy monitoring dashboards

This directory contains an example allow you to deploy Cloud Monitoring dashboards using [Terraform](https://www.terraform.io/). If it's your first time using Terraform on GCP, you can read the materials listed in the resource section below.

## Usage
The [dashboards](../dashboards) directory contains JSON examples for monitoring dashboards.

Under this directory, run the following commands and provide proper arguments:

```bash
terraform init
terraform plan
terraform apply
```

You can also provide the arguments directly in the CLI, for example:

```bash
terraform apply -var 'dashboard_json_file=../dashboards/storage/cloud-storage-monitoring.json' \
 -var 'project_id=[your_project_id]'
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| dashboard\_json\_file | The JSON file of the dashboard | string | n/a | yes |
| project\_id | The ID of the project in which the dashboard will be created | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| project\_id | The project in which the dashboard was created |
| resource\_id | The resource id for the dashboard |
| console\_link | The destination console URL for the dashboard |


## MSP Info

1. Need help variablizing this for ease of use for each client; portability
2. Need help centralizing views for the dashboard into ONE or across several project; Think of scoping project
3. Need help testing this aka Demo
4. Need help with Notification Channel
5. Need help with Ops Agent: 
    - if required
    - if not required
    - ignore