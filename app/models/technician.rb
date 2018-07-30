# frozen_string_literal: true

# Representa un técnico que realiza servicios técnicos.
#
class Technician < ApplicationRecord
  has_many :technical_service_technicians, dependent: :restrict_with_error

  validates :firstname, :lastname, presence: true
  validates :firstname, uniqueness: { scope: [:lastname],
                                      case_sensitive: false }
  validates :lastname, uniqueness: { scope: [:firstname],
                                     case_sensitive: false }

  scope :active, -> { where(active: true) }

  include FullNameSearchable
end
