# frozen_string_literal: true

# Representa el tipo de instalación de estabilizador, UPS o protector que tiene
# el cliente en su instalación.
#
class SurgeProtectorSetupType < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
