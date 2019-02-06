# frozen_string_literal: true

# Job que se encarga de crear un cliente en Contabilium.
# Sincronización Maxwell -> Contabilium.
#
class Contab::ClientEditJob
  include Sidekiq::Worker

  def perform(client_id)
    client = Client.find(client_id)

    contab_client = Contab::Client.from_model(client)

    return if contab_client.save || !Rails.env.production?

    logger.error("Client ID #{client.id} could not be updated in Contabilium."\
                 " Response was: '#{contab_client.response_errors.join(';')}'")
  end
end
