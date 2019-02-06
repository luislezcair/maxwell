# frozen_string_literal: true

# Job que se encarga de actualizar un cliente en UCRM con los datos de un
# cliente existente en Maxwell, luego de que este último haya sido modificado.
#
class UCRM::ClientEditRemoteJob
  include Sidekiq::Worker

  def perform(client_id)
    client = Client.find(client_id)
    ucrm_client = UCRM::Client.from_model(client)

    # TODO: si actualizamos los contactos, estos se duplican en UCRM. Hay
    # que actualizar a través de clients/:id/contacts.
    ucrm_client.attributes.delete(:contacts)

    if !ucrm_client.save && Rails.env.production?
      logger.error("Client ID #{client.id} could not be updated in UCRM")
    end

    ucrm_client
  end
end
