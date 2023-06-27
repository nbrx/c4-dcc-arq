# Patron de Diseño Broker

* Status: Aprobado
* Deciders: Nebur Alvarez
* Date: 2023-06-11

## Context and Problem Statement

La Exposición de servicios internet debe abarcar consideraciones de seguridad, ratios de uso, monitoreo y métricas:

* Securitizar APIs con OpenID Connect
* Instalación Api Gateway on-premises y cloud (AWS, Azure, GCP, etc), y por lo tanto cercano a los servicios que se busca exponer.
* Realizar una gestión sobre cuotas de peticiones
* Realizar una gestión sobre tasa de peticiones

## Decision Drivers

* Disminuir complejidad de administración.
* Disminuir complejidad en los desarrollos.
* Plataformas usables para desarrollos web onpremise/cloud o de aplicaciones móviles.

## Considered Options

* Plataforma API Management y GateWay
* Balanceador de Carga
* Cluster de Web Server por DNS

## Decision Outcome

Las Plataformas de  API Management y Gateway, Es la mejor opción dado que normalmente estas plataformas se implementan con Load Balancer y Cluster de Servidores Web. Además incorpora gestión de API y abstracción de localización de los recursos.

## Pros and Cons

### Pros

* Agrega Seguridad via Configuración en un entorno no seguro (Internet).
* Se logra gestionar aspectos como la limitación de velocidad, el control de acceso de usuarios, la autorización de tokens, el escalado, reducir complejidad.
* Mpnitoreo y análisis que ayudan a los desarrolladores a depurar y crear infraestructuras que pueden escalar con facilidad

### Contras

* ***Curva de aprendizaje***
* ***Único punto de falla***
* ***Requiere una orquestación de servicios***
* ***Degradación del rendimiento:*** es una preocupación debido a la multitud de escenarios que manejará API Gateway y puede afectar la velocidad y la confiabilidad de su aplicación.

### Patron Seleccionado 

***Plataforma API Management y GateWay***
