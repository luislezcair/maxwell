# frozen_string_literal: true

# Representa el trabajo que realiza un técnico en el domicilio de un cliente
# durante un servicio técnico.
#
class WorkType < ApplicationRecord
  has_many :technical_service_work_types, dependent: :restrict_with_error
  has_many :technical_services, through: :technical_service_work_types

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
