class Technician < ApplicationRecord
  has_many :technical_service_technicians, dependent: :restrict_with_error

  validates :firstname, :lastname, presence: true
  validates :firstname, uniqueness: { scope: [:lastname],
                                      case_sensitive: false }

  include FullNameSearchable
end
