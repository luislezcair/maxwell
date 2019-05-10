# frozen_string_literal: true

# Representa un balanceador de carga utilizado en la instalación de un cliente.
#
class Balancer < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
