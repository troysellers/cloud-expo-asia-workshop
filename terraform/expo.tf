resource "aiven_pg" "pg" {
  project = var.project_name
  cloud_name = var.cloud_name
  plan                    = "business-4"
  service_name            = var.pg-service-name
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"
}