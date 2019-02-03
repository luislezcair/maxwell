# frozen_string_literal: true

# Clase que representa un Webhook de UCRM, una notificación de eventos que viene
# desde UCRM cada vez que sucede un evento de nuestro interés, como crear un
# cliente, una antena, un dispositivo, etc.
#
class UcrmWebhook < ApplicationRecord
  extend Enumerize

  enumerize :status, in: [:pending, :processing, :completed, :error],
                     default: :pending,
                     predicates: true

  validates :uuid, :change_type, :entity, :entity_id, :event_name,
            presence: true

  EVENT_JOBS = {
    'client.add': UCRM::ClientAddJob,
    'client.edit': UCRM::ClientEditJob
  }.freeze

  # Crea una nueva instancia UcrmWebhook parseando los datos en formato JSON
  # @param json [Hash] datos del webhook como vienen desde UCRM.
  #
  def self.from_json(json)
    new(uuid: json[:uuid],
        change_type: json[:changeType],
        entity: json[:entity],
        entity_id: json[:entityId],
        event_name: json[:eventName])
  end

  # Devuelve un Hash con los atributos con nombres tal como los envía UCRM
  # para ser transformados a JSON.
  #
  def to_hash
    {
      uuid: uuid,
      changeType: change_type,
      entity: entity,
      entityId: entity_id,
      eventName: event_name
    }
  end

  # Cambia el estado de este webhook a `processing`
  #
  def processing!
    self.status = :processing
    save!
  end

  # Cambia el estado de este webhook a `completed`
  #
  def completed!
    self.status = :completed
    save!
  end

  # Cambia el estado de este webhook a `error` y establece un mensaje de error
  # @param msg [String] motivo del error. Este valor se establece en el
  # atributo `error_msg`
  #
  def error!(msg = nil)
    self.status = :error
    self.error_msg = msg
    save!
  end

  # Lanza el job adecuado para manejar el evento del webhook. La asociación
  # entre eventos y jobs está definida en EVENT_JOBS.
  #
  def launch_action
    return false unless persisted? && EVENT_JOBS.include?(event_name.to_sym)

    EVENT_JOBS[event_name.to_sym].perform_async(id)
  end
end
