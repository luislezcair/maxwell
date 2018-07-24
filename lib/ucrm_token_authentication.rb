# frozen_string_literal: true

# Implementa un Middleware de Faraday (la librería utilizada por Her para hacer
# las llamadas REST) que colocal en cada request a la API de UCRM la cabecera
# HTTP con la API Key.
# La clave se encuentra en el archivo encriptado config/credentials.yml.enc
#
class UcrmTokenAuthentication < Faraday::Middleware
  def call(env)
    rails_env = :development # Rails.env
    env[:request_headers]['X-Auth-App-Key'] =
      Rails.application.credentials[:ucrm][rails_env][:api_key]
    @app.call(env)
  end
end
