
workspace "Sistema de Difusión de Contenidos" {

    model {
        user = person "Usuario" "Comunidad DCC, Universitaria y publico en general"
        adminUser = person "Área de Difusión" "Área encargada de crear distintos contenidos para el departamento"
        sysadmin = person "Área de Sistemas"
        docentes = person "Docentes"


        softwareSystemDBMS = softwareSystem "Base de datos Sistema de Difusión de Contenidos"{
            dbmsDifusionContenidos = container "DBMS Difusión de Contenidos" {
                 tags "gris"
            }
           
        }

        sofwareSystempubsub = softwareSystem "PubSub" "Streaming Messaging"{
            pubsub = container "Message pubsub"{
                tags "gris"
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
            tv = container "TV" {tags "gris"}
        }
        
        softwareSystemUnoticias = softwareSystem "U-Noticias" "Sistema de publicación noticias" "Paneles de Noticias y comunicación con TV" {
            unoticias = container "U-Noticia"{
                tags "gris"
                this -> tv "Muetra contenido en TV"
            }
            
        }
        softwareSystemUCampus = softwareSystem "U-Campus" "Sistema gestión docente" {
            ucampus = container "U-Campus" {
                tags "gris"
                }
            ucampus -> pubUCampus "replica estructura"
            ucampus -> pubUCampus "replica estructura"
        }
         
        softwareSystemUPaper = softwareSystem "U-Paper" "Sistema gestión documentos de investigación científica" {
            upaper = container "U-Papers" {
                tags "gris"
            }
            upaper -> pubUPaper  "replica papers"
        }



        softwareSystemGateWay = softwareSystem "Broker" "Plataforma para la ejecución y administración de API"{
            gateway = container "Gateway" {
                tags "gris"
                apiUNoticias = component "API U-Noticias"
                apiDifusionContenidos = component "API Difusion de Contenido"
            }
            apiUNoticias -> unoticias "crea noticia"
        }

        softwareSystem = softwareSystem "Software Difusión de Contenidos" "Gestión de contenidos para la Universidad" "Contenido difusión blog dinámico" {
            !docs docs
            !adrs adrs
            tags "azul"
            webapp = container "Sitio Web Publico" "" "nextjs" {
                tags "azul"
                user -> this "Consume Contenido"   
                user -> this "Comenta Post"
                docentes -> this "Escribe un blog"
                adminUser -> this "Publica y Gestiona Contenido de Difusión"
                sysadmin -> this "Administra y opera la infraestructura"

                models = component "Modelo"
                view = component "Vista"
                controler = component "Controlador"
                controler -> models "pulls data setter"
                controler -> view "push data setters"
                view -> controler "request user data"
                controler -> apiDifusionContenidos "request data from API"
                
            }

            
            apiDifusionContenidos -> dbmsDifusionContenidos "Lee y escribe"
            webapp -> apiUNoticias "crea noticia"

  
        }

        deloymentWebServer = deploymentEnvironment "Web Server"{
            deploymentNode "WebApp"{
                containerInstance webapp
                deploymentNode "NGNIX"
            }
        }


    }

    views {
        systemLandscape {
            include *
            autoLayout lr
        }

        styles {

            element "Person" {
                shape Person
            }

            element "gris" {
                background #1168bd
                color #ffffff
                shape RoundedBox
            }
            element "azul" {
                background #174a75
                color #ffffff
                shape RoundedBox
            }
        }
    

        systemContext softwareSystem {
            include *
            autolayout lr
        }

        container softwareSystem {
            include *
            autolayout lr
        }

        component webapp {
            include *
            autoLayout lr
        }

        component gateway {
            include *
            autoLayout lr
        }

        component pubsub {
            include *
            autoLayout lr
        }
 


    }

}