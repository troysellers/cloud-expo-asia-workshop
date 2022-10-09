resource "aiven_pg" "pg" {
  project = var.project_name
  cloud_name = var.cloud_name
  plan                    = "business-4"
  service_name            = var.pg-service-name
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"
}

# PostgreSQL Service
resource "aiven_pg" "postgres-service" {

  project      = var.aiven_project_name
  cloud_name   = var.aiven_cloud
  plan         = var.aiven_plan
  service_name = "${var.service_prefix}service-pg"
}

provider "postgresql" {
  alias           = "pg"
  host            = aiven_pg.postgres-service.service_host
  port            = aiven_pg.postgres-service.service_port
  database        = "defaultdb"
  username        = aiven_pg.postgres-service.service_username
  password        = aiven_pg.postgres-service.service_password
  sslmode         = "require"
  connect_timeout = 15
}

# Kafka Service
resource "aiven_kafka" "kafka-service" {
  project                 = var.aiven_project_name
  cloud_name              = var.aiven_cloud
  plan                    = var.aiven_plan
  service_name            = "${var.service_prefix}service-kafka"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"

  kafka_user_config {
    kafka_connect   = true
    kafka_rest      = true
    kafka_version   = "3.2"
    schema_registry = true
    kafka {
      auto_create_topics_enable    = true
    }
  }
}


# Debezium Source Connector
resource "aiven_kafka_connector" "kafka-pg-source-conn" {
  project        = var.aiven_project_name
  service_name   = aiven_kafka.kafka-service.service_name
  connector_name = "kafka-pg-source-conn"

  config = {
    "name"                     = "kafka-pg-source-conn",
    "connector.class"          = "io.debezium.connector.postgresql.PostgresConnector",
    "tasks.max"                = "1",
    "database.server.name"     = aiven_pg.postgres-service.service_name,
    "database.hostname"        = aiven_pg.postgres-service.service_host,
    "database.port"            = aiven_pg.postgres-service.service_port,
    "database.user"            = aiven_pg.postgres-service.service_username,
    "database.password"        = aiven_pg.postgres-service.service_password,
    "database.dbname"          = "defaultdb",
    "plugin.name"              = "pgoutput",
    "database.sslmode"         = "require",
    "publication.name"         = "debezium_publication"
    "slot.name"                = "debezium",
    "key.converter"            = "org.apache.kafka.connect.storage.StringConverter",
    "value.converter"          = "org.apache.kafka.connect.json.JsonConverter"
  }
}



# M3 Service
resource "aiven_m3db" "m3db-metrics" {
  project      = var.aiven_project_name
  cloud_name   = var.aiven_cloud
  plan         = "startup-8"
  service_name = "${var.service_prefix}metrics-m3db"
}


resource "aiven_grafana" "grafana" {
  project      = var.aiven_project_name
  cloud_name   = var.aiven_cloud
  plan         = "startup-4"
  service_name = "${var.service_prefix}metrics-grafana"
}

#Clickhouse service
resource "aiven_clickhouse" "clickhouse" {
  project                 = var.aiven_project_name
  cloud_name              = var.aiven_cloud
  plan                    = "startup-beta-8"
  service_name            = "${var.service_prefix}clickhouse"
  maintenance_window_dow  = "monday"
  maintenance_window_time = "10:00:00"
}

#Service integration - PostgreSQL 
resource "aiven_service_integration" "pg-metrics" {
  project                  = var.aiven_project_name
  integration_type         = "metrics"
  source_service_name      = aiven_pg.postgres-service.service_name
  destination_service_name = aiven_m3db.m3db-metrics.service_name
}

#Service integration - Kafka 
resource "aiven_service_integration" "kafka-metrics" {
  project                  = var.aiven_project_name
  integration_type         = "metrics"
  source_service_name      = aiven_kafka.kafka-service.service_name
  destination_service_name = aiven_m3db.m3db-metrics.service_name
}

#Service integration - Grafana 
resource "aiven_service_integration" "int-grafana-m3db" {
  project                  = var.aiven_project_name
  integration_type         = "dashboard"
  source_service_name      = aiven_grafana.grafana.service_name
  destination_service_name = aiven_m3db.m3db-metrics.service_name
}

