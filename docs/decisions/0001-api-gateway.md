# API Gateway

* Status: accepted
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

* Plataforma Tyk

## Decision Outcome

Chosen option: "Plataforma Tyk", because comes out best.

## Pros and Cons of the Options

### Plataforma Tyk

La Exposición de servicios internet debe abarcar consideraciones de seguridad, ratios de uso, monitoreo y métricas. La plataforma Tyk viene a cubrir estas consideraciones.
En este contexto Tyk permite:
    • Securitizar APIs con OpenID Connect.
    • Instalación Api Gateway on-premises, y por lo tanto cercano a los servicios que se busca exponer.
    • Realizar una gestión sobre cuotas de peticiones. 
    • Realizar una gestión sobre tasa de peticiones.
    • Ver resúmenes de actividad sobre cada API, https://tyk.io/docs/tyk-dashboard-analytics/traffic-overview/.
