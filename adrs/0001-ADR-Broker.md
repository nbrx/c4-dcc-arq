# Patron de Diseño Broker

* Status: Aprobado
* Deciders: Nebur Alvarez
* Date: 2023-06-11

## Context and Problem Statement

El diseño e implementación de una API requiere tener en cuenta varios aspectos técnicos, requerimientos no funcionales y patrones de software, que involucra además administrar varios tipos de escenarios de consumo, tales como: 
    • Diversas opciones de proveedores de seguridad y estándares.
    • Clientes de aplicación con requerimientos diferentes a las provistas por los servicios existentes.
    • Composición de datos para vistas específicas para aplicaciones.
    • Condiciones de performance de red diferentes por clientes de aplicación.
    • Rutas de acceso localizadas en diferentes instancias On-premises o Cloud.
    • Servicios que usan diversos protocolos.
    • Microservicios.
¿De qué manera se pueden abordar estos requerimientos asociados al uso de APIs?

## Decision Drivers

* Disminuir complejidad de administración.
* Disminuir complejidad en los desarrollos.
* Plataformas usables para desarrollos web onpremise/cloud o de aplicaciones móviles.

## Considered Options

* Plataforma API Management y GateWay
* Balanceador de Carga
* Cluster de Web Server por DNS

## Decision Outcome

Chosen option: "Plataforma API Management y GateWay", Es la mejor opción dado que normalmente estas plataformas se implementan con Load Balancer y Cluster de Servidores Web. Además incorpora gestión de API y abstracción de localización de los recursos.

## Pros and Cons of the Options

Especificar

### Plataforma API Management y GateWay

La Exposición de servicios internet debe abarcar consideraciones de seguridad, ratios de uso, monitoreo y métricas. La plataforma API Management y GateWay viene a cubrir estas consideraciones.
En este contexto permite:
* Securitizar APIs con OpenID Connect
* Instalación Api Gateway on-premises y cloud (AWS, Azure, GCP, etc), y por lo tanto cercano a los servicios que se busca exponer.
* Realizar una gestión sobre cuotas de peticiones
* Realizar una gestión sobre tasa de peticiones