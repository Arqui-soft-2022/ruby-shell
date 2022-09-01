# Ruby Shell

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## Descripción 📑

Aplicación de consola que permite registrarse e iniciar sesión con el objetivo de generar código QR y tipo de formato a partir de una URL

## Instalación de Ruby y gemas (dependencias) necesarias para el proyecto

### Instalar Ruby para Windows
[Ruby 3.0.4] https://rubyinstaller.org/downloads/

### Instalar la gema Bundler: manejador de dependencias para Ruby
```bash
   gem install bundler
```
Configurando proyecto con Bundler: se crea archivo Gemfile en donde se van a añadir las gemas que se van a usar.
```bash
   bundle init
```
Añadimos la gemas listadas en el archivo Gemfile

Luego de añadir las dependencias que se necesiten al gemfile, ejecutamos el siguiente comando para descargar las dependencias (se crea un archivo gemfile.lock):
```bash
   bundle install
```
Y listo, ya podemos crear un archivo main.rb y hacer uso de las dependencias

- Ejecutar ```ruby main.rb ``` para version1 
- Ejecutar ```ruby request_test.rb ``` para version2


## Autores ✒️

let team = ['Johan Pineda', 'Jhoser Pacheco'];

**Ingeniería de Sistemas** de la **Universidad Francisco de Paula Santander** **[2022]
