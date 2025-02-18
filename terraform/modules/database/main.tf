resource "exoscale_database" "db" {
  name               = var.database.name
  type               = var.database.type
  zone               = var.zone
  plan               = var.database.size
  termination_protection = false

  pg {
    version = var.database.version
    backup_schedule = "04:00"

    pg_settings = jsonencode({
      timezone : "Europe/Vienna"
    })
  }

  maintenance_dow  = "sunday"
  maintenance_time = "20:00:00"

  lifecycle {
    prevent_destroy = false
  }
}

data "exoscale_database_uri" "database" {
  zone = var.zone
  type = var.database.type
  name = var.database.name

  depends_on = [
    exoscale_database.db
  ]
}
