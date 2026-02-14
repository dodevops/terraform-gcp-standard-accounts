output "emails" {
  description = "A map of standard service account short names to their full email addresses."
  value       = local.all_emails
}

output "iam_members" {
  description = "A map of standard service account short names to their IAM member format (e.g., 'serviceAccount:email@...'). Useful for IAM bindings."
  value       = local.all_iam_members
}
