// Definir y crear el grupo de recursos donde iran incluidos todos los componentes de la aplicacion

// Azure provider se puede utilizar para configurar la infraestructura en Microsoft Azure mediante las API de Azure Resource Manager
provider "azurerm"{
    features{}
    subscription_id = ""
}

// Crear el grupo de recursos de Azure
resource "azurerm_resource_group" "rg" { //Tenemos que dar nombre a la definicion para usarlo en la configuracion de otros recursos

    name = "rg-${var.project}-${var.environment}"
    location = var.location
    tags = var.tags

}