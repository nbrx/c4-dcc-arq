
workspace "Sistema de gestión de Contenidos" {

    model {
        user = person "Usuario" "Comunidad DCC, Universitaria y publico en general"
        adminUser = person "Área de Difusión" "Área encargada de crear distintos contenidos para el departamento"
        sysadmin = person "Área de Sistemas"
        docentes = person "Docentes"


        softwareSystemDBMS = softwareSystem "Base de datos"{
            dbmsDifusionContenidos = container "DBMS Difusión de Contenidos" 
            tags "gris"
        }

        sofwareSystempubsub = softwareSystem "PubSub" "Streaming Messaging"{
            tags "gris"
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

        softwareSystemTv = softwareSystem "Sistema de TV" "Sistema de visualización de noticias y eventos en los monitores instalados en los pasillos del DCC"{
            tags "gris"
            tv = container "TV"
        }
        
        softwareSystemUnoticias = softwareSystem "U-Noticias" "Sistema de publicación noticias" "Paneles de Noticias y comunicación con TV" {
            tags "gris"
            unoticias = container "U-Noticia"{
                this -> tv "Muetra contenido en TV"
            }
            
        }
        softwareSystemUCampus = softwareSystem "U-Campus" "Sistema gestión docente" {
            tags "gris"
            ucampus = container "U-Campus"
            ucampus -> pubUCampus "replica estructura"
            ucampus -> pubUCampus "replica estructura"
        }
         
        softwareSystemUPaper = softwareSystem "U-Paper" "Sistema gestión documentos de investigación científica" {
            tags "gris"
            upaper = container "U-Papers"
            upaper -> pubUPaper  "replica papers"
        }



        softwareSystemGateWay = softwareSystem "Broker" "Plataforma para la ejecución y administración de API"{
            tags "gris"
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
            autolayout lr
        }

                deployment * deloymentWebServer {
            include *
            autoLayout lr
        }

        deployment * deploymentDBMS {
            include *
            autoLayout lr
        }
        
        styles {
            element "Tag 1" {
                background #1168bd
                color #ffffff
                shape RoundedBox
            }
        }
    }
    

}