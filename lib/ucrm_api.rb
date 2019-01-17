# frozen_string_literal: true

require 'ucrm_token_authentication'
require 'ucrm_response_parser'
require 'ucrm_request_builder'

# Clase que crea y configura Her para la comunicación con la API de UCRM.
#
class UCRMAPI
  def api
    Her::API.new url: UCRM_API_URL, send_only_modified_attributes: true do |c|
      # Request
      c.use UcrmRequestBuilder
      c.use FaradayMiddleware::EncodeJson
      c.use UcrmTokenAuthentication

      # Response
      c.use UcrmResponseParser

      if Rails.env.development?
        # Agregar bodies: true al final si es necesario para depurar
        c.use Faraday::Response::Logger, ActiveSupport::Logger.new(STDOUT)
      end

      # Adapter
      c.use Faraday::Adapter::NetHttp
    end
  end
end
