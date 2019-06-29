# frozen_string_literal: true

# Guarda variables de configuración de Maxwell. Lo hacemos en la base de datos
# para que puedan modificarse libremente después y no tener que hacer cambios en
# el código o archivos de configuración que requieran commit, push, deploy.
#
class SystemConfiguration < ApplicationRecord
  # Atajo que devuelve el valor de una variable de configuración `name` de
  # acuerdo al entorno RAILS donde estemos actualmente. El entorno puede
  # sobreescribirse especificando el parámetro `env`
  #
  def self.get(name, default = '', env = ENV['RAILS_ENV'])
    r = find_by(name: name)

    return default unless r

    if env && env.to_sym == :production
      r.production_value
    else
      r.development_value
    end
  end

  # Atajo para obtener una variable de configuración referida a las APIs, ya
  # que estas se manejan de acuerdo al entorno definido en APIS_ENV.
  #
  def self.get_api_config(name, env = ENV['APIS_ENV'])
    get(name, env)
  end
end
