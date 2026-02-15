terraform {
  required_version = "~> 1.0" # Specify compatible Terraform CLI versions

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
  # A map of accounts whose names are derived from the project number
  emails = {
    app_engine_default       = "${var.project_id}@appspot.gserviceaccount.com"
    gce_default              = "${data.google_project.this.number}-compute@developer.gserviceaccount.com"
    cloud_build              = "${data.google_project.this.number}@cloudbuild.gserviceaccount.com"
    google_apis_agent        = "${data.google_project.this.number}@cloudservices.gserviceaccount.com"
    pubsub_agent             = "service-${data.google_project.this.number}@gcp-sa-pubsub.iam.gserviceaccount.com"
    cloud_sql_agent          = "service-${data.google_project.this.number}@gcp-sa-cloud-sql.iam.gserviceaccount.com"
    container_registry_agent = "service-${data.google_project.this.number}@containerregistry.iam.gserviceaccount.com"
    kms_agent                = "service-${data.google_project.this.number}@gcp-sa-cloudkms.iam.gserviceaccount.com"
    bigquery_agent           = "service-${data.google_project.this.number}@gcp-sa-bigquery.iam.gserviceaccount.com"
  }

  # A map of all service accounts in the format required for IAM bindings
  iam_members = {
    app_engine_default       = "serviceAccount:${local.emails.app_engine_default}"
    gce_default              = "serviceAccount:${local.emails.gce_default}"
    cloud_build              = "serviceAccount:${local.emails.cloud_build}"
    google_apis_agent        = "serviceAccount:${local.emails.google_apis_agent}"
    pubsub_agent             = "serviceAccount:${local.emails.pubsub_agent}"
    cloud_sql_agent          = "serviceAccount:${local.emails.cloud_sql_agent}"
    container_registry_agent = "serviceAccount:${local.emails.container_registry_agent}"
    kms_agent                = "serviceAccount:${local.emails.kms_agent}"
    bigquery_agent           = "serviceAccount:${local.emails.bigquery_agent}"
  }
}
