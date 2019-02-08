# frozen_string_literal: true

# Job que se encarga de obtener los datos de un cliente mediante una llamada a
# la API de UCRM y de crearlo localmente. Este job se dispara en respuesta a
# una notificación desde UCRM con el evento "client.add".
#
# También encola un Contab::ClientCreateJob para crear el cliente en
# Contabilium.
#
class UCRM::ClientAddJob
  include Sidekiq::Worker

  def perform(webhook_id)
    webhook = UcrmWebhook.find(webhook_id)
    webhook.processing!

    client = UCRM::Client.find(webhook.entity_id)

    # TODO: Los clientes en UCRM tienen varios service plans. Habría que
    # obtener el primero al menos para asociarlo a Cliente.

    return unless (c = client&.to_maxwell_model)

    if c.save
      webhook.completed!
      Contab::ClientCreateJob.perform_async(c.id)
    else
      webhook.error!(c.errors.messages.to_json)
    end
  end
end
