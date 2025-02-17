variable "zone" {
  description = "Exoscale zone"
  type        = string
}

variable "database" {
  description = "Database configuration"
  type = object({
    name          = string
    type          = string
    version       = string
    size          = string
    storage_size  = number
    node_count    = number
  })
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}