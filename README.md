# GCP Standard Service Accounts Terraform Module

This module provides convenient access to the email addresses of standard, auto-created GCP service accounts whose names are predictably derived from the project ID and project number.

It simplifies referencing these accounts in IAM policies and other resources without having to manually construct the names.

## Usage Example

```terraform
# In your main.tf or other configuration file

# You first need to get your project's data
data "google_project" "this" {
  project_id = "your-gcp-project-id"
}

# Instantiate the module
module "standard_accounts" {
  source     = "./gcp-standard-accounts"
  project_id = data.google_project.this.project_id
}

# Example: Grant the GCE default service account access to a secret
resource "google_secret_manager_secret_iam_member" "gce_access" {
  project   = data.google_project.this.project_id
  secret_id = "my-super-secret"
  role      = "roles/secretmanager.secretAccessor"

  # Use the 'iam_members' output map
  member = module.standard_accounts.iam_members.gce_default
}

# Example: Output the email of the Cloud Build service account
output "cloud_build_service_account_email" {
  # Use the 'emails' output map
  value = module.standard_accounts.emails.cloud_build
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_google"></a> [google](#requirement\_google) | >= 3.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_google"></a> [google](#provider\_google) | >= 3.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [google_project.this](https://registry.terraform.io/providers/hashicorp/google/latest/docs/data-sources/project) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The unique, user-assigned ID of the GCP project. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_emails"></a> [emails](#output\_emails) | A map of standard service account short names to their full email addresses. |
| <a name="output_iam_members"></a> [iam\_members](#output\_iam\_members) | A map of standard service account short names to their IAM member format (e.g., 'serviceAccount:email@...'). Useful for IAM bindings. |
<!-- END_TF_DOCS -->

### Available Keys

The following keys are available in both the `emails` and `iam_members` output maps:

- `gce_default`
- `cloud_build`
- `google_apis_agent`
- `pubsub_agent`
- `cloud_sql_agent`
- `container_registry_agent`
- `kms_agent`
- `bigquery_agent`
- `app_engine_default` (Also used by 1st Gen Cloud Functions)
