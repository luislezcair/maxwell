# frozen_string_literal: true

# Representa la frecuencia (en Hz) de comunicación del dispositivo del cliente
# con la torre emisora.
#
class Transmitter < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
