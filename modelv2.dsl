
workspace "Sistema de Difusión de Contenidos" {

    model {
        user = person "Usuario" "Comunidad DCC, Universitaria y publico en general"
        adminUser = person "Área de Difusión" "Área encargada de crear distintos contenidos para el departamento"
        sysadmin = person "Área de Sistemas"
        docentes = person "Docentes"


        softwareSystemTv = softwareSystem "Sistema de TV" "Sistema de visualización de noticias y eventos en los monitores instalados en los pasillos del DCC"{
            tv = container "TV" {tags "Sistemas Externos"}
        }
        
        softwareCuentasUChile = softwareSystem "cuentas u-chile" "Sistema que administra la identida, autorización y autenticación de las cuentas de usuario de la Uniersidad de Chile"{
            rbacUChile = container "RBAC U.Chile" {
                tags "Sistemas Externos"
            }
        }

        softwareuProyects = softwareSystem "u-proyectos" "Sistema que administra los proyectos de la Uniersidad de Chile"{
            uproyectos = container "U-Proyectos" {
                tags "Sistemas Externos"
            }
        }
        

        softwareSystemUnoticias = softwareSystem "U-Noticias" "Sistema de publicación noticias" "Paneles de Noticias y comunicación con TV" {
            unoticias = container "U-Noticia"{
                tags "Sistemas Externos"
                this -> tv "Muetra contenido en TV"
            }
            
        }
        softwareSystemUCampus = softwareSystem "U-Campus" "Sistema gestión docente" {
            ucampus = container "U-Campus" {
                tags "Sistemas Externos"
                }
        }
         
        softwareSystemUPaper = softwareSystem "U-Paper" "Sistema gestión documentos de investigación científica" {
            upaper = container "U-Papers" {
                tags "Sistemas Externos"
            }  
        }


        softwareSystem = softwareSystem "Software Difusión de Contenidossss" "Gestión de contenidos para la Universidad" "Contenido difusión blog dinámico" {
            !docs docs
            !adrs adrs
            tags "Sistema Difusión de Contenido"

            gateway = container "Gateway" {
                tags "Sistema Difusión de Contenido"
                apiUNoticias = component "API U-Noticias"
                apiUCampus = component "API U-Campus"
                apiDifusionContenidos = component "API Difusion de Contenido" {
                    tags "Sistema Difusión de Contenido"
                }
            }
            

            dbmsDifusionContenidos = container "DBMS Difusión de Contenidos" {
                 tags "Sistema Difusión de Contenido, dbms"
            }

            pubsub = container "Message pubsub"{
                tags "Sistema Difusión de Contenido, Pipe"
                pubUCampus = component "Publicador U-Campus"
                pubUPaper = component "Publicador U-Paper"
                pubUproyectos = component "Publicador U-Proyectos"
                subUCampus = component "Subcriptor U-Campus" "Suscriptor para replica de datos hacia el sistema de difusión de contenidos"{
                    tags "Sistema Difusión de Contenido"
                }
                subUPaper = component "Subcriptor U-Paper" "Suscriptor para replica de datos hacia el sistema de difusión de contenidos"{
                    tags "Sistema Difusión de Contenido"
                }
            
            }

            cdnSGC = container "CDN contenido estático" "cdn" {
                tags "Sistema Difusión de Contenido"
            }


            webappSDC = container "Sitio Web Publico" "" "nextjs" {
                tags "Sistema Difusión de Contenido, webapp"
                user -> this "Consume Contenido"   
                user -> this "Comenta Post"
                docentes -> this "Escribe un blog"
                adminUser -> this "Publica y Gestiona Contenido de Difusión"
                sysadmin -> this "Administra y opera la infraestructura"

                models = component "Modelo" {
                     tags "Sistema Difusión de Contenido"
                }
                view = component "Vista" {
                     tags "Sistema Difusión de Contenido"
                }
                controler = component "Controlador" {
                     tags "Sistema Difusión de Contenido"
                }
                controler -> models "pulls data setter"
                controler -> view "push data setters"
                view -> controler "request user data"
                view -> models "display data getter"
                controler -> apiDifusionContenidos "request data from API"
            }

            backendSDC = container "Backend"  "Software Difusión de Contenido" {
                tags "Sistema Difusión de Contenido"
            }
  
        }

        webappSDC -> apiDifusionContenidos "Consume Servicio API SDC"
        apiDifusionContenidos -> backendSDC "Consume Servicio Backend SDC"
        backendSDC -> dbmsDifusionContenidos "Lee y escribe esquma SDC"
        webappSDC -> cdnSGC "referencia recursos estaticos"

        webappSDC -> apiUNoticias "Consume API Backend U-Noticias"
        apiUNoticias -> unoticias "Consume Servicio Backend U-Noticias"
        
        webappSDC -> apiUCampus "Consume API Backend U-Campus" 
        apiUCampus -> ucampus "Consume Servicio Backend U-Campus"
        
        
        

        webappSDC -> rbacUChile "verifica autenticación/autorización" "[OIDC]"

        #relaciones pubsub
        uproyectos -> pubUproyectos "replica proyectos de investigación" "[pubsub]"
        upaper -> pubUPaper  "replica publicaciones cientificas" "[pubsub]"
        pubUPaper -> subUPaper "subcribe replica u-papers" "[pubsub]"
        subUPaper -> dbmsDifusionContenidos "recibe replica u-papers" "[pubsub]"

        
            

        deloymentWebServer = deploymentEnvironment "Web Server"{
            deploymentNode "webappSDC"{
                containerInstance webappSDC
                deploymentNode "NGNIX"
            }
        }


    }

    views {
        systemLandscape {
            include *
        }

        styles {

            element "Person" {
                shape Person
            }

            element "dbms" {
                shape Cylinder
            }

            element "webapp" {
                shape WebBrowser
            }

            element "Pipe" {
                shape Pipe
            }

            element "Sistemas Externos" {
                background #BEBEBE
                color #ffffff
                shape RoundedBox
            }
            element "Sistema Difusión de Contenido" {
                background #2273B5
                color #ffffff
                shape RoundedBox
            }
        }
    

        container softwareSystem {
            include *
            autolayout lr
        }

        component webappSDC {
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

        theme default
 


    }

}