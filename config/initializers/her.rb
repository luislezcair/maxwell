# frozen_string_literal: true

require 'ucrm_token_authentication'
require 'ucrm_response_parser'

UCRM_API = Her::API.new

UCRM_API.setup url: 'https://clientes.diezpositivo.com.ar/api/v1.0' do |config|
  # Request
  config.use Faraday::Request::UrlEncoded
  config.use UcrmTokenAuthentication

  # Response
  config.use UcrmResponseParser

  if Rails.env.development?
    config.use Faraday::Response::Logger, ActiveSupport::Logger.new(STDOUT)
  end

  # Adapter
  config.use Faraday::Adapter::NetHttp
end
