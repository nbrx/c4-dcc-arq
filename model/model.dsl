
workspace "Sistema de gestión de Contenidos" {

    model {
        user = person "Comunidad DCC, Universitaria y publico en general"
        adminUser = person "Área de Difusión"
        sysadmin = person "Área de Sistemas"

        softwareSystem = softwareSystem "Software Difusión de Contenidos" "Gestión de contenidos para la Universidad" "Contenido difusión blog dinámico" {
            !docs docs
            !adrs adrs

            webapp = container "Sitio Web Publico" "" "nextjs" {
                user -> this "Consume Contenido"   
                user -> this "Comenta Post"
                adminUser -> this "Publica y Gestiona Contenido de Difusión"
                sysadmin -> this "Administra y opera la infraestructura"
            }

            dbmsDifusionContenidos = container "DBMS Difusión de Contenidos" 

            gateway = container "Gateway" {
                apiUNoticias = component "API U-Noticias"
                apiDifusionContenidos = component "API Difusion de Contenido"
            }

            
            unoticias = container "U-Noticia"
            ucampus = container "U-Campus"
            upaper = container "U-Papers"
            broker = container "Message Broker"{
                pubUCampus = component "Publicador U-Campus"
                pubUPaper = component "Publicador U-Paper"
                subUCampus = component "Subcriptor U-Campus"
                subUPaper = component "Subcriptor U-Paper"
                pubUCampus -> subUCampus "subcribe replica estructura"
                subUCampus -> dbmsDifusionContenidos "recibe replica estructura"
                pubUPaper -> subUPaper "subcribe replica papers" 
                subUPaper -> dbmsDifusionContenidos "recibe replica papers"
                
            }
            
            
            webapp -> apiDifusionContenidos "conecta con api"
            apiDifusionContenidos -> dbmsDifusionContenidos "Lee y escribe"
            apiDifusionContenidos -> apiUNoticias "crea noticia"

            apiUNoticias -> unoticias "crea noticia"
            upaper -> pubUPaper  "replica papers"
            ucampus -> pubUCampus "replica estructura"
            
        }

        deloymentWebServer = deploymentEnvironment "Web Server"{
            deploymentNode "WebApp"{
                containerInstance webapp
                deploymentNode "NGNIX"
            }
        }

        deploymentDBMS = deploymentEnvironment "DBMS Server" {
            deploymentNode "DBMS" {
                containerInstance dbmsDifusionContenidos
                deploymentNode "PostgreSQL"
            }
        }

    }

    views {
        systemLandscape {
            include *
            autoLayout lr
        }
        systemContext softwareSystem {
            include *
            autolayout lr
        }

        container softwareSystem {
            include *
            autolayout lr
        }

        component gateway {
            include *
            autoLayout lr
        }

        component broker {
            include *
            autoLayout lr
        }
        deployment * deloymentWebServer {
            include *
            autoLayout lr
        }

        deployment * deploymentDBMS {
            include *
            autoLayout lr
        }



        

        theme default
    }

}