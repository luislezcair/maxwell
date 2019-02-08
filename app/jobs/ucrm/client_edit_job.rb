# frozen_string_literal: true

# Job que se encarga de obtener los datos de un cliente mediante una llamada a
# la API de UCRM y de modificar el cliente correspondiente local. Este job se
# dispara en respuesta a una notificación desde UCRM con el evento "client.add".
#
# También encola un Contab::ClientEditJob para modificar el cliente en
# Contabilium.
#
class UCRM::ClientEditJob
  include Sidekiq::Worker

  def perform(webhook_id)
    webhook = UcrmWebhook.find(webhook_id)
    webhook.processing!

    client = UCRM::Client.find(webhook.entity_id)

    # TODO: Los clientes en UCRM tienen varios service plans. Habría que
    # obtener el primero al menos para asociarlo a Cliente.

    # Si llegó un evento de edición pero el cliente no existe localmente,
    # informo el error y termino
    return webhook.error!(error_message) unless (local = client&.maxwell_model)

    if local.update(client.to_maxwell_model.attributes_for_ucrm_update)
      webhook.completed!
      Contab::ClientEditJob.perform_async(local.id)
    else
      webhook.error!(local.errors.messages.to_json)
    end
  end

  private

  def error_message
    I18n.t('activerecord.errors.models.ucrm_webhook.client.edit_non_existant')
  end
end
