// Una VNET administra una red virtual que incluye todas las subredes configuradas. Cada subred se puede configurar opcionalmente con un grupo de seguridad que se asociará con la subred.
resource "azurerm_virtual_network" "vnet"{
    
    name = "vnet-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    location = var.location
    address_space = ["10.10.0.0/16"]
    tags = var.tags

}

resource "azurerm_subnet" "subnetdb"{
    
    name = "subnet-db-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.10.1.0/24"]

}

resource "azurerm_subnet" "subnetapp"{
    
    name = "subnet-app-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.10.2.0/24"]
    
}

resource "azurerm_subnet" "subnetweb"{
    
    name = "subnet-web-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.10.3.0/24"]

    delegation {
        name = "webapp_delegation"
        service_delegation {
            name    = "Microsoft.Web/serverFarms"
            actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
    }

}

resource "azurerm_subnet" "subnetfunction"{
    
    name = "subnet-function-${var.project}-${var.environment}"
    resource_group_name = azurerm_resource_group.rg.name
    virtual_network_name = azurerm_virtual_network.vnet.name
    address_prefixes = ["10.10.4.0/24"]

}