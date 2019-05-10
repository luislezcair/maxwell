# frozen_string_literal: true

# Representa el tipo de soporte que sostiene la antena (device) en la
# instalación de un cliente.
#
class SupportType < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
