variable "az_sub_id" {}
variable "az_tenant_id" {}
variable "az_client_id" {}
variable "az_client_secret" {}
variable "az_location" {}
variable "az_location_pg" {}
variable "pguser" {}
variable "pgpassword" {}

provider "azurerm" {
  subscription_id = "${var.az_sub_id}"
  tenant_id = "${var.az_tenant_id}"
  client_id = "${var.az_client_id}"
  client_secret = "${var.az_client_secret}"
  version = "~> 1.0" 
}

resource "azurerm_resource_group" "databases" {
  name = "databases"
  location = "${var.az_location}"
}

resource "azurerm_postgresql_server" "pg-server" {
  name = "pg-server-01"
  location = "${var.az_location_pg}"
  resource_group_name = "${azurerm_resource_group.databases.name}"

  sku {
    name = "PGSQLB50"
    capacity = 50
    tier = "Basic"
  }

  administrator_login = "${var.pguser}"
  administrator_login_password = "${var.pgpassword}"
  version = "9.6"
  storage_mb = "51200"
  ssl_enforcement = "Disabled"
}

resource "azurerm_postgresql_firewall_rule" "pg-fw-rule" {
  name                = "unsafe-allow-all"
  resource_group_name = "${azurerm_resource_group.databases.name}"
  server_name         = "${azurerm_postgresql_server.pg-server.name}"
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}

resource "azurerm_postgresql_database" "pg-go-web" {
  name                = "goweb"
  resource_group_name = "${azurerm_resource_group.databases.name}"
  server_name         = "${azurerm_postgresql_server.pg-server.name}"
  charset             = "UTF8"
  collation           = "en_US"
}