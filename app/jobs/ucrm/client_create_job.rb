# frozen_string_literal: true

# Job que se encarga de crear un cliente en UCRM con los datos de un cliente
# existente en Maxwell.
#
class UCRM::ClientCreateJob
  include Sidekiq::Worker

  def perform(client_id)
    client = Client.find(client_id)
    ucrm_client = UCRM::Client.from_model(client)

    if ucrm_client.save
      client.ucrm_id = ucrm_client.id
      client.save
    elsif Rails.env.production?
      logger.error("Client ID #{client.id} could not be created in UCRM")
    end

    ucrm_client
  end
end
