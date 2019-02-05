# frozen_string_literal: true

# Job que se encarga de crear un cliente en Contabilium.
# Sincronización Maxwell -> Contabilium.
#
class Contab::ClientCreateJob
  include Sidekiq::Worker

  def perform(client_id)
    client = Client.find(client_id)

    contab_client = Contab::Client.from_model(client)

    if contab_client.save
      client.contabilium_id = contab_client.response_id
      client.save
    else
      logger.error("Client ID #{client.id} could not be created in Contabilium")
    end
  end
end
