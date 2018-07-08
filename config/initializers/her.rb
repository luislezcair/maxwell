# frozen_string_literal: true

require 'ucrm_token_authentication'

Her::API.setup url: 'https://clientes.diezpositivo.com.ar/api/v1.0' do |config|
  # Request
  config.use Faraday::Request::UrlEncoded
  config.use UcrmTokenAuthentication

  # Response
  config.use Her::Middleware::DefaultParseJSON

  if Rails.env.development?
    config.use Faraday::Response::Logger, ActiveSupport::Logger.new(STDOUT)
  end

  # Adapter
  config.use Faraday::Adapter::NetHttp
end
