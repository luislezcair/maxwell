# frozen_string_literal: true

# Representa un proceso que se ejecuta en Sidekqiq. Por ahora solamente trata
# BillingExports, pero la idea es que sea general y trate otro tipo de procesos.
#
# Provee atributos para guardar el estado del proceso, un mensaje de error si
# hubo, una descripción más detallada del estado si es necesario y un campo
# progress entero para indicar algún tipo de progreso.
#
class BackgroundJob < ApplicationRecord
  extend Enumerize

  belongs_to :job_item, polymorphic: true

  enumerize :status, in: { enqueued: 0,
                           working: 1,
                           finished: 2,
                           error: 3 },
                     default: :enqueued,
                     predicates: true

  # Actualiza el estado del Job y lo guarda
  #
  def set_status_and_save(status, detail, progress = nil, error = nil)
    self.status = status if status
    self.detailed_status = detail if detail
    self.error_msg = error if error
    self.progress = progress if progress
    save!
  end
end
