# frozen_string_literal: true

# Representa el dispositivo que se encuentra instalado en una Torre, que recibe
# las conexiones de los clientes.
#
class Tower < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :ucrm_site_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
