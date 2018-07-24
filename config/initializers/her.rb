# frozen_string_literal: true

require 'ucrm_token_authentication'
require 'ucrm_response_parser'

UCRM_API = Her::API.new

UCRM_API.setup url: 'https://ucrm-testing.diezpositivo.com.ar/api/v1.0' do |c|
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
