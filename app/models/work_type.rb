class WorkType < ApplicationRecord
  has_many :technical_service_work_types, dependent: :restrict_with_error

  validates :name, presence: true
end
