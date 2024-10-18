variable "project"{
    description = "Nombre del proyecto"
    default = "sistcont"
}

variable "environment"{
    description = "the enviroment to release"
    default = "dev"
}

variable "location"{
    description = "Azure region"
    default = "East Us 2"
}

variable "tags"{
    description = "Todas las etiquetas utilizadas"
    default = {
        environment = "dev"
        project = "Proyecto de Sistema Contable"
        created_by = "Franklin Gutierrez"
    }
}

variable "password"{
    description = "sqlserver password"
    type = string
    sensitive = true
}