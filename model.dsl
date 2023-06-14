
workspace "Sistema de gestión de Contenidos" {

    model {
        user = person "Comunidad DCC, Universitaria y publico en general"
        adminUser = person "Área de Difusión"
        sysadmin = person "Área de Sistemas"
        docentes = person "Docentes"


        softwareSystemDBMS = softwareSystem "Cluster de Base de datos"{
            dbmsDifusionContenidos = container "DBMS Difusión de Contenidos" 
        }

        sofwareSystempubsub = softwareSystem "PubSub" "Streaming Messaging"{
            pubsub = container "Message pubsub"{
            pubUCampus = component "Publicador U-Campus"
            pubUPaper = component "Publicador U-Paper"
            subUCampus = component "Subcriptor U-Campus"
            subUPaper = component "Subcriptor U-Paper"
            pubUCampus -> subUCampus "subcribe replica estructura"
            subUCampus -> dbmsDifusionContenidos "recibe replica estructura"
            pubUPaper -> subUPaper "subcribe replica papers" 
            subUPaper -> dbmsDifusionContenidos "recibe replica papers"
            
            }
        }

        softwareSystemUnoticias = softwareSystem "Software U-Noticias" "Sistema de publicación noticias" "Paneles de Noticias y comunicación con TV" {
            unoticias = container "U-Noticia"
        }
        softwareSystemUCampus = softwareSystem "Software U-Campus" "Sistema gestión docente" {
            ucampus = container "U-Campus"
            ucampus -> pubUCampus "replica estructura"
        }
        softwareSystemUPaper = softwareSystem "Software U-Paper" "Sistema gestión documentos de investigación científica" {
            upaper = container "U-Papers"
            upaper -> pubUPaper  "replica papers"
        }



        softwareSystemGateWay = softwareSystem "API Gateway" "Plataforma para ejecución de API"{
            gateway = container "Gateway" {
                apiUNoticias = component "API U-Noticias"
                apiDifusionContenidos = component "API Difusion de Contenido"
            }
            apiUNoticias -> unoticias "crea noticia"
        }

        softwareSystem = softwareSystem "Software Difusión de Contenidos" "Gestión de contenidos para la Universidad" "Contenido difusión blog dinámico" {
            !docs docs
            !adrs adrs

            webapp = container "Sitio Web Publico" "" "nextjs" {
                user -> this "Consume Contenido"   
                user -> this "Comenta Post"
                docentes -> this "Escribe un blog"
                adminUser -> this "Publica y Gestiona Contenido de Difusión"
                sysadmin -> this "Administra y opera la infraestructura"
            }

            
            
            
            
            webapp -> apiDifusionContenidos "conecta con api"
            apiDifusionContenidos -> dbmsDifusionContenidos "Lee y escribe"
            webapp -> apiUNoticias "crea noticia"

            
            
           
            
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

        component pubsub {
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