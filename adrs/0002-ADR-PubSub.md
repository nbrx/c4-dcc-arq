# Patron de Diseño PubSub

* Status: Aprobado
* Deciders: Nebur Alvarez
* Date: 2023-06-11

## Context and Problem Statement

En un sistema que requiere desplegar información de diversas fuentes que provienen de sistemas que no se pueden modificar es un patrón de mensajería permitiría capturar los eventos de DML de la base de datos para despachar en formato de mensajes a un canal sin saber quién los va a recibir. Es responsabilidad del canal entregar una copia de los mensajes a cada suscriptor.

## Decision Drivers

* Desplegar información de sistemas que no se pueden modificar.
* Disminuir complejidad en los desarrollos
* Disminuir complejidad de administración

## Considered Options

* PubSub
* Pipe and Filter

## Decision Outcome

Las Plataformas que implementan Pub/Sub, Es la mejor opción dado que la intervención es a nivel de base de datos y no son invasivas a la modificación de una aplicación, debido que replican a nivel de datalog los datos a otra base de datos o almacenamiento en la nube.

## Pros and Cons of the Options

### Pros

* ***Bajo acoplamiento***: Los publicadores están vagamente vinculados a los suscriptores y ni siquiera necesitan saber de su existencia. Los publicadores y suscriptores pueden permanecer ignorantes de la topología del sistema. Cada uno puede continuar funcionando normalmente independientemente del otro.

* ***Escalabilidad***: Pub/sub brinda una mejor escalabilidad que el cliente-servidor tradicional, a través de operación paralela, almacenamiento en caché de mensajes, enrutamiento basado en árbol o basado en red.

### Cons

* Problemas de entrega de mensajes: Un sistema pub/sub debe diseñarse cuidadosamente para poder proporcionar propiedades de sistema más sólidas que una aplicación en particular podría requerir, como la entrega asegurada.

* Almacenamiento Distribuído: Un sistema pub/sub debe diseñarse para escalar el almacenamiento compartido de los nodos que estarán desplegados en la infrastructura y deben estar dimensionados para contener el historico de eventos a mantener para la reconstrucción de los eventos y de la transaccionalidad de los sistemas.

### Patron Seleccionado

***Pub/Sub***