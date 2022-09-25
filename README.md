
# Ejemplo Tareas: Wiremock - Backend mockeado

## Instrucciones

### Instalación

- Descargar [Wiremock](https://wiremock.org/docs/download-and-installation/) en modo standalone, ubicarlo en el raíz del proyecto
- Editar el archivo [`wiremock.sh`](./wiremock.sh) para que apunte a la versión correcta del jar descargado. 

### Cómo hicimos el mapeo

Inicialmente podés levantar el puerto 8080 como proxy del puerto donde está algún backend, y seleccionar la opción `record mappings` para que genere los archivos con los mapeos correspondientes.

```bash
java -jar wiremock-jre8-standalone-2.34.0.jar --port 8080 --proxy-all http://localhost:9000 --record mappings
```

- Levantás el backend real en el puerto 9000
- Desde Insomnia le pegás al puerto 8080 con las llamadas a los endpoints, siguiendo [este archivo de configuración](./Insomnia_GrabarEndpoints.json). Eso va a generar una lista de archivos json con los pedidos y archivos de mapeo que van a especificar si los métodos http son PUT, POST, DELETE, GET, etc. Es un primer paso, no es suficiente sin duda.

> En este repositorio nosotros ya cambiamos los archivos de mapping, así que no tenés que hacer eso.

### Qué hace Wiremock

Si te fijás el comando que levanta por consola es

```bash
java -jar wiremock-jre8-standalone-2.34.0.jar --port 9000
```

Esto genera un backend de prueba, algo útil

- si no tenés ambiente de [_staging_](https://www.commonplaces.com/blog/web-development-what-is-staging/) o [_review apps_](https://docs.gitlab.com/ee/ci/review_apps/)
- si necesitás hacer pruebas asépticas que no genere información basura que pueda molestar a usuarios que hacen prueba
- si necesitás hacer una prueba de cómo hace los pedidos REST tu aplicación frontend y cómo procesa las respuestas, y sabés que los tests de frontend no te dan esa cobertura (porque terminás mockeando los servicios)
- si incluso tenés un backend real pero algunas partes necesitás mockearlas porque no tenés control sobre los servicios web, o bien porque es costoso (en términos de performance o de plata, si te cobran por requests)

Una vez que levantaste este backend, podés ejecutar los tests e2e de cypress de Tareas, siguiendo [este repositorio]()

## Escenarios

Para poder testear todo el flujo de las tareas siguiendo un camino feliz, tuvimos que configurar escenarios que es básicamente la posibilidad de definir estados por los que pasan los endpoints, asumiendo que

- vamos a crear una tarea, esto modifica el método `GET` de `/tareas`, donde primero pasamos 3 tareas, y luego 4
- luego vamos a asignar la tarea, esto requiere
  - definir el estado inicial y final para el método `PUT` de `/tareas/4`
  - el `GET` de `/tareas` ahora muestra un asignatario en la última tarea
  - en el `GET` de `/tareas/4` sucede lo mismo: antes no había asignatario y ahora sí
- luego cumplimos la tarea, lo que require
  - definir el estado inicial y final para el método `PUT` de `/tareas/4` (% de cumplimiento pasa de 0 a 100)
  - el `GET` de `/tareas` ahora muestra la última tarea totalmente cumplida
  - en el `GET` de `/tareas/4` sucede lo mismo: pasamos de 0 a 100 en el cumplimiento
- por último, al borrar la tarea, tenemos que volver a iniciar el circuito, para que Cypress pueda ejecutar nuevamente el flujo de tests sin que se rompan todas las aserciones.

## Más información

- [Documentación oficial de Wiremock](https://wiremock.org/docs/download-and-installation/)
- Podés ver [esta charla de Rosanne Joosten](https://www.youtube.com/watch?v=ddUMyLsDkLw&ab_channel=Devoxx) donde cuenta algunas características de Wiremock.
