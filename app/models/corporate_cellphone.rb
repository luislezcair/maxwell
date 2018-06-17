class CorporateCellphone < ApplicationRecord
  has_many :technical_service_corporate_cellphones,
           dependent: :restrict_with_error

  validates :phone, presence: true, uniqueness: true

  scope :sorted, -> { order(:phone) }

  def to_label
    phone
  end
end
