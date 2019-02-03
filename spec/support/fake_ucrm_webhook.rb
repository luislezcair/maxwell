# frozen_string_literal: true

require 'faraday'

# Clase que imita los webhooks de UCRM para usarlos en pruebas
#
class FakeUcrmWebhook
  # Crea un nuevo objeto FakeUCRMWebhook para enviar notificación de eventos
  #
  # @param webhook [String] nombre del archvio de fixture que se va a utilizar
  # en el cual se define el tipo de evento y el id de objeto afectado.
  # @param host [String] nombre de host donde se va a enviar la notificación
  # @param port [Integer] puerto en el host donde se va a enviar la notificación
  # @param path [String] URI o ruta a donde se hace POST con el evento
  #
  def initialize(webhook:, host:, port:, path:)
    @host = host
    @path = path
    @port = port

    load_webhook(webhook)
    construct_connection
  end

  # Envía la solicitud o webhook al host:puert/ruta definido al construir el
  # objecto
  #
  def send
    @connection.post do |request|
      request.url @path
      request.headers = @headers
      request.body = JSON.generate(@body)
    end
  end

  attr_accessor :body

  private

  def construct_connection
    @connection = Faraday.new(url: "http://#{@host}:#{@port}")
  end

  def load_webhook(webhook)
    @headers = { 'Content-Type': 'application/json' }
    @body = webhook.to_hash
  end
end
