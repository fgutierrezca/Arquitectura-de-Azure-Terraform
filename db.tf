// Administra un servidor de base de datos de Microsoft SQL Azure
resource "azurerm_mssql_server" "sql_server"{

    name = "sqlserver-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    version = "12.0"
    administrator_login = "sqladmin"
    administrator_login_password = var.password

    tags = var.tags

}

// Administra una base de datos MS SQL.
resource "azurerm_mssql_database" "sql_db" { 

    name = "sistcont.db"
    server_id = azurerm_mssql_server.sql_server.id
    sku_name = "S0" // S0 de las bases de datos mas baratas

    tags = var.tags

}

// Azure Private Endpoint es una interfaz de red que lo conecta de forma privada y segura a un servicio impulsado por Azure Private Link. Private Endpoint usa una dirección IP privada de su red virtual, lo que permite que el servicio ingrese a su red virtual. 
resource "azurerm_private_endpoint" "sql_private_endpoint"{ //Conectar el segmento de red con el servidor de base de datos

    name = "sql-private-endpoint-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    subnet_id = azurerm_subnet.subnetdb.id

    private_service_connection { //Como conectar a la base datos
        name = "sql-private-ec-${var.project}-${var.environment}"
        private_connection_resource_id = azurerm_mssql_server.sql_server.id
        subresource_names = ["sqlServer"]
        is_manual_connection = false
    }

    tags = var.tags

}

// Le permite administrar zonas DNS privadas dentro de Azure DNS. Estas zonas están alojadas en servidores de nombres de Azure
resource "azurerm_private_dns_zone" "private_dns_zone"{ 
    
    name= "private.dbserver.database.windows.net"
    resource_group_name = azurerm_resource_group.rg.name

    tags = var.tags

}

// Le permite administrar registros DNS A dentro de DNS privado de Azure
resource "azurerm_private_dns_a_record" "private_dns_a_record"{ 

    name = "sqlserver-record-${var.project}-${var.environment}"
    zone_name = azurerm_private_dns_zone.private_dns_zone.name
    resource_group_name = azurerm_resource_group.rg.name
    ttl = 300
    records = [azurerm_private_endpoint.sql_private_endpoint.private_service_connection[0].private_ip_address]

}

// Le permite administrar vínculos de red virtual de la zona DNS privada. Estos vínculos permiten la resolución y el registro de DNS dentro de las redes virtuales de Azure mediante DNS privado de Azure
resource "azurerm_private_dns_zone_virtual_network_link" "vnet_link"{ 

    name = "vnetlink-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
    virtual_network_id = azurerm_virtual_network.vnet.id

}

// Le permite administrar una regla de firewall de Azure SQL, que estas reglas permiten o rechazan las conexiones hacia o desde las instancias
resource "azurerm_mssql_firewall_rule" "allow_my_ip_net" {
  
    name                = "FirewallRule1"
    server_id         = azurerm_mssql_server.sql_server.id
    start_ip_address    = "221.192.18.155"
    end_ip_address      = "221.192.18.155"

}