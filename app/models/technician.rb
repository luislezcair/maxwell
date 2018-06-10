class Technician < ApplicationRecord
  has_many :technical_service_technicians, dependent: :restrict_with_error

  validates :name, presence: true
end
