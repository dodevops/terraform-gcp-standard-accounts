terraform {
  required_version = "~> 1.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.0.0"
    }
  }
}

data "google_project" "this" {
  project_id = var.project_id
}

locals {
  # A map of accounts whose names are derived from the project ID
  by_project_id = {
    app_engine_default = "${var.project_id}@appspot.gserviceaccount.com"
  }

  # A map of accounts whose names are derived from the project number
  by_project_number = {
    gce_default              = "${data.google_project.this.number}-compute@developer.gserviceaccount.com"
    cloud_build              = "${data.google_project.this.number}@cloudbuild.gserviceaccount.com"
    google_apis_agent        = "${data.google_project.this.number}@cloudservices.gserviceaccount.com"
    pubsub_agent             = "service-${data.google_project.this.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
    cloud_sql_agent          = "service-${data.google_project.this.number}@gcp-sa-cloud-sql.iam.gserviceaccount.com"
    container_registry_agent = "service-${data.google_project.this.number}@containerregistry.iam.gserviceaccount.com"
    kms_agent                = "service-${data.google_project.this.number}@gcp-sa-cloudkms.iam.gserviceaccount.com"
    bigquery_agent           = "service-${data.google_project.this.number}@gcp-sa-bigquery.iam.gserviceaccount.com"
  }

  # The final map of all service account emails, keyed by a short name
  all_emails = merge(
    local.by_project_number,
    local.by_project_id
  )

  # The final map of all service accounts in the format required for IAM bindings
  all_iam_members = {
    for name, email in local.all_emails :
    name => "serviceAccount:${email}"
  }
}
