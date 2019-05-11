# Maxwell

[![Build Status](https://travis-ci.com/luislezcair/maxwell.svg?token=ZTezY5pdSseyfJxAaZH6&branch=master)](https://travis-ci.com/luislezcair/maxwell)

Maxwell es un sistema orientado a ISPs para el registro y facturación de servicios técnicos realizados por personal de la empresa en el domicilio de clientes.

Se integra con [UCRM](https://ucrm.ui.com) de Ubiquiti para consumir datos de clientes, dispositivos, sitios y facturas y con el sistema contable [Contabilium](https://www.contabilium.com) a través de sus APIs REST.

## Demo

Deploy en un click a Heroku. Usuario y contraseña por defecto `admin` y `admin-123`.

[![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy?template=https://github.com/luislezcair/maxwell)

## Instalación

Clonar el repositorio e instalar las dependencias

```
$ git clone https://github.com/luislezcair/maxwell.git
$ bundle install --path=vendor/bundle
$ yarn install
```

Crear la base de datos y cargar los datos iniciales

```
$ bundle exec rails db:migrate
$ bundle exec seeds:initial_data
```

Crear el usuario administrador. Por defecto usuario `admin` y contraseña `admin-123`

```
$ bundle exec seeds:admin_user
```

¡Listo! Sólo queda ejecutar la aplicación:

```
$ bundle exec rails s
```


## Testing

La mayor parte de la aplicación está cubierta con pruebas de integración utilizando RSpec:

```
$ bundle exec rspec
```

## Licencia

Este proyecto está disponible bajo los términos de la licencia GNU General Public License v3.0 detallada en LICENSE.md.

## Contribuciones

Reporte de errores y pull requests son siempre bienvenidos [aquí mismo](https://github.com/luislezcair/maxwell/issues).

## Copyright

Copyright (c) 2019 Luis Lezcano Airaldi
