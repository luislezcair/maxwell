class CorporateCellphone < ApplicationRecord
  has_many :technical_service_corporate_cellphones,
           dependent: :restrict_with_error

  validates :phone, presence: true
end
