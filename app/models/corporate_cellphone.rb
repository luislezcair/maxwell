# frozen_string_literal: true

# Representa un teléfono celular de la empresa.
#
class CorporateCellphone < ApplicationRecord
  # YOLO:
  include ActionView::Helpers::NumberHelper

  has_many :technical_service_corporate_cellphones,
           dependent: :restrict_with_error

  validates :phone, presence: true, uniqueness: true

  scope :sorted, -> { order(:phone) }

  # (1234) 567 890
  def to_label
    number_to_phone(phone, area_code: true, delimiter: ' ',
                           pattern: /(\d{4})(\d{3})(\d{3})$/)
  end
end
