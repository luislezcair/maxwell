# frozen_string_literal: true

# Representa el tipo de instalación de cable a tierra que posee (o no) un
# cliente (si tiene, no tiene, si fue instalado por la empresa, etc.)
#
class GroundWireSetupType < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
