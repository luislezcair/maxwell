class WorkType < ApplicationRecord
  has_many :technical_service_work_types, dependent: :restrict_with_error
  has_many :technical_services, through: :technical_service_work_types

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
