
workspace "Sistema de Difusión de Contenidos" {

    model {
        user = person "Usuario" "Comunidad DCC, Universitaria y publico en general"
        adminUser = person "Área de Difusión" "Área encargada de crear distintos contenidos para el departamento"
        sysadmin = person "Área de Sistemas"
        docentes = person "Docentes"


        softwareSystemTv = softwareSystem "Sistema de TV" "Sistema de visualización de noticias y eventos en los monitores instalados en los pasillos del DCC"{
            tags "Sistemas Externos"
            tv = container "TV" {tags "Sistemas Externos"}
        }
        
        softwareCuentasUChile = softwareSystem "cuentas u-chile" "Sistema que administra la identida, autorización y autenticación de las cuentas de usuario de la Uniersidad de Chile"{
             tags "Sistemas Externos"
            rbacUChile = container "RBAC U.Chile" {
                tags "Sistemas Externos"
            }
        }

        softwareuProyects = softwareSystem "u-proyectos" "Sistema que administra los proyectos de la Uniersidad de Chile"{
             tags "Sistemas Externos"
            uproyectos = container "U-Proyectos" {
                tags "Sistemas Externos"
            }
        }
        

        softwareSystemUnoticias = softwareSystem "U-Noticias" "Sistema de publicación noticias" "Paneles de Noticias y comunicación con TV" {
             tags "Sistemas Externos"
            unoticias = container "U-Noticia"{
                tags "Sistemas Externos"
                this -> tv "Muetra contenido en TV"
                adminUser -> this "administra notificas"
            }
            
        }
        softwareSystemUCampus = softwareSystem "U-Campus" "Sistema gestión docente" {
            tags "Sistemas Externos"
            ucampus = container "U-Campus" {
                tags "Sistemas Externos"
                }
        }
         
        softwareSystemUPaper = softwareSystem "U-Paper" "Sistema gestión documentos de investigación científica" {
            tags "Sistemas Externos"
            upaper = container "U-Papers" {
                tags "Sistemas Externos"
            }  
        }


        softwareSystem = softwareSystem "Software Difusión de Contenidos" "Gestión de contenidos para la Universidad" "Contenido difusión blog dinámico" {
            !docs docs
            !adrs adrs
            tags "Sistema Difusión de Contenido"

            gateway = container "Gateway" {
                tags "Sistema Difusión de Contenido, Gateway"
                apiUNoticias = component "API U-Noticias"
                apiUCampus = component "API U-Campus"
                apiDifusionContenidos = component "API Difusion de Contenido" {
                    tags "Sistema Difusión de Contenido"
                }
            }
            

            dbmsDifusionContenidos = container "DBMS Difusión de Contenidos" {
                 tags "Sistema Difusión de Contenido, dbms"
            }

            pubsub = container "Message pubsub" "Cola de mensajeria del software de difusión de contenido" "NAT JetStream"{
                tags "Sistema Difusión de Contenido, Pipe"
                pubUPaper = component "Publicador U-Paper"
                pubUproyectos = component "Publicador U-Proyectos"
                subUproyectos = component "Subcriptor U-Proyectos" "Suscriptor para replica de datos hacia el sistema de difusión de contenidos"
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
                unoticiasAdapter = component "Adaptador Formato U-Noticias"

                controler -> models "pulls data setter"
                controler -> view "push data setters"
                view -> controler "request user data"
                view -> models "display data getter"
                controler -> apiDifusionContenidos "Consume Servicio API SDC" "broker"
                controler -> apiUNoticias "Consume API Backend U-Noticias" "broker"
                controler -> unoticiasAdapter "Adapta formato para Sitio Público" "library"

            }

            backendSDC = container "Backend"  "Software Difusión de Contenido" {
                tags "Sistema Difusión de Contenido"
            }
  
        }


        apiDifusionContenidos -> backendSDC "Consume Servicio Backend SDC" "service"
        backendSDC -> dbmsDifusionContenidos "Lee y escribe esquma SDC" "repository"
        webappSDC -> cdnSGC "referencia recursos estaticos" "https"

      
        apiUNoticias -> unoticias "Consume Servicio Backend U-Noticias" "service"
        
        webappSDC -> apiUCampus "Consume API Backend U-Campus" "broker"
        apiUCampus -> ucampus "Consume Servicio Backend U-Campus" "service"
        
        
        

        webappSDC -> rbacUChile "verifica autenticación/autorización" "OIDC"

        #relaciones pubsub
        uproyectos -> pubUproyectos "replica proyectos de investigación" "pubsub"
        pubUproyectos -> subUproyectos "subcribe replica u-proyectos" "pubsub" 
        subUproyectos -> dbmsDifusionContenidos "recibe replica u-proyectos" "pubsub" 
        upaper -> pubUPaper  "replica publicaciones cientificas" "pubsub"
        pubUPaper -> subUPaper "subcribe replica u-papers" "pubsub"
        subUPaper -> dbmsDifusionContenidos "recibe replica u-papers" "pubsub"

        
        live = deploymentEnvironment "Live" {
            deploymentNode "DCC" {
                region = deploymentNode "Data Center Region 1" {
                    dnsuchile = infrastructureNode "DNS"
                    lb = infrastructureNode "Load Balancer"
                    k8s = deploymentNode "Nodos de Auto Escalado" "Cluster Kubernates" "K8S" {
                        ingress = infrastructureNode "Ingress Controller"
                        egress = infrastructureNode "Egress"
                        deploymentNode "WebApp" "3x replica set" "NGINX " {
                            webappSDCInstance = containerInstance webappSDC
                            
                        }
                        deploymentNode "Nodo Static Resources" "3x replica set" "NGINX" {
                            cdnSGCInstance = containerInstance cdnSGC
                        }
                        deploymentNode "Nodo Backend" "3x replica set" "NodeJS" {
                            backendSDCInstance = containerInstance backendSDC
                        }

                        deploymentNode "Nodo API Gateway" "3x replica set" "KONG" {
                            gatewaySDCInstance = containerInstance gateway
                        }

                        deploymentNode "Nodo Nats JetStream" "3x replica set" "Nats JetStream" {
                            natsjetstreamSDCInstance = containerInstance pubsub
                        }
                  
                    }
                    deploymentNode "DBMS Cluster" {
                        deploymentNode "PostgreSQL" {
                            dbmsDifusionContenidosInstance = containerInstance dbmsDifusionContenidos
                        }
                    } 
                }

                dnsuchile -> lb
                lb -> ingress
                egress -> dnsuchile
                lb -> dbmsDifusionContenidosInstance
                ingress -> webappSDCInstance
                ingress -> cdnSGCInstance
                ingress -> gatewaySDCInstance
                ingress -> natsjetstreamSDCInstance

            }
        }
            

        deloymentWebServer = deploymentEnvironment "Web Server"{
            deploymentNode "webappSDC"{
                containerInstance webappSDC
                deploymentNode "NGNIX"
            }
        }


    }

    views {

        deployment softwareSystem "Live" {
            include *

            animation {
                webappSDCInstance
                dbmsDifusionContenidosInstance
                cdnSGCInstance
                gatewaySDCInstance
                backendSDCInstance
                natsjetstreamSDCInstance
                dnsuchile
                lb
            }

        }

        systemLandscape {
            include *
            animation {
                softwareSystem
                softwareCuentasUChile
                softwareSystemUnoticias
                softwareSystemTv
                softwareuProyects
                softwareSystemUPaper
                softwareSystemUCampus
                adminUser
                user
                sysadmin
                docentes

            }
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

            element "Gateway" {
                shape Hexagon
            }

            element "Sistemas Externos" {
                background #999999
                color #ffffff
                shape RoundedBox
            }
            element "Sistema Difusión de Contenido" {
                background #1168bd
                color #ffffff
                shape RoundedBox
            }
        }
    

        container softwareSystem {
            include *
        }

        component webappSDC {
            include *
            autoLayout lr
            animation {
                view
                models
                controler
                unoticiasAdapter

                
            }
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