# frozen_string_literal: true

require 'ucrm_token_authentication'
require 'ucrm_response_parser'

# Clase que crea y configura Her para la comunicación con la API de UCRM.
#
class UCRMAPI
  def api
    Her::API.new url: UCRM_API_URL do |c|
      # Request
      c.use FaradayMiddleware::EncodeJson
      c.use UcrmTokenAuthentication

      # Response
      c.use UcrmResponseParser

      if Rails.env.development?
        c.use Faraday::Response::Logger, ActiveSupport::Logger.new(STDOUT)
      end

      # Adapter
      c.use Faraday::Adapter::NetHttp
    end
  end
end
