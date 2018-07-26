# frozen_string_literal: true

require 'contab_response_parser'

# Clase que crea un Her::API para Contabilium. Se hace en una clase porque
# Contabilium utiliza OAuth2, lo que requiere hacer antes una solicitud para
# obtener un Token que se va a usar en las llamadas subsiguientes a la API.
# Luego, la API se crea con el token obtenido.
#
class ContabAPI
  SITE = 'https://rest.contabilium.com'
  API_ENDPOINT = 'https://rest.contabilium.com/api'
  TOKEN_ENDPOINT = '/token'

  # Crea un nuevo Her::API con los parámetros para Contabilium
  #
  def api
    Her::API.new url: API_ENDPOINT do |config|
      # Request
      config.use Faraday::Request::UrlEncoded
      config.use FaradayMiddleware::OAuth2, read_token, token_type: :bearer

      # Response
      config.use ContabResponseParser

      if Rails.env.development?
        config.use Faraday::Response::Logger, ActiveSupport::Logger.new(STDOUT)
      end

      # Adapter
      config.use Faraday::Adapter::NetHttp
    end
  end

  private

  # Obtiene el último token de la base de datos. Si es válido lo devuelve. Si
  # ya expiró obtiene uno nuevo llamando a `new_token` y lo guarda.
  #
  def read_token
    last = AuthToken.last_token
    if last&.still_valid?
      last.token
    else
      new_token.token
    end
  end

  # Realiza una llamada OAuth2 a Contabilium para obtener un nuevo token.
  # TODO: handle Faraday::ConnectionFailed, change env to actual env
  #
  def new_token
    credentials = Rails.application.credentials[:contabilium][CONTABILIUM_ENV]

    client_id = credentials[:client_id]
    client_secret = credentials[:client_secret]

    client = OAuth2::Client.new(client_id, client_secret, oauth_options)
    token = client.client_credentials.get_token
    AuthToken.create_from_response(token.token, token.expires_at)
  end

  def oauth_options
    {
      site: SITE,
      token_url: TOKEN_ENDPOINT,
      auth_scheme: :request_body,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/x-www-form-urlencoded'
      }
    }
  end
end
