# frozen_string_literal: true

# Implementa un Middleware de Faraday (la librería utilizada por Her para hacer
# las llamadas REST) que colocal en cada request a la API de UCRM la cabecera
# HTTP con la API Key.
# La clave se encuentra en el archivo encriptado config/credentials.yml.enc
#
class UcrmTokenAuthentication < Faraday::Middleware
  def call(env)
    env[:request_headers]['X-Auth-App-Key'] =
      Rails.application.credentials[:ucrm_api_key]
    @app.call(env)
  end
end
