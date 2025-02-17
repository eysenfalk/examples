output "name" {
  description = "Database name"
  value       = var.database.name
}

output "uri" {
  description = "Database URI"
  value       = data.exoscale_database_uri.database.uri
}

output "user" {
  description = "Database user"
  value       = data.exoscale_database_uri.database.username
}

output "port" {
  description = "Database port"
  value       = data.exoscale_database_uri.database.port
}

