# frozen_string_literal: true

# Representa una empresa u organización. Los servicios técnicos pueden
# realizarse para clientes de otras empresas y, al facturar, el código de cuenta
# y el IdConcepto depende de la empresa a la que se brindó el servicio.
#
class Organization < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, :concept_id, presence: true

  scope :sorted, -> { order(:name) }
end
