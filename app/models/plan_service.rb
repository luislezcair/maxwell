# frozen_string_literal: true

# Representa un Plan de Servicio que posee un cliente. El plan de servicio
# establece la velocidad de conexión y el monto mensual que se le va a facturar
# al cliente.
#
class PlanService < ApplicationRecord
  has_many :clients, dependent: :restrict_with_error
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
