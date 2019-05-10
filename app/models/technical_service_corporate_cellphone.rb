# frozen_string_literal: true

# Representa un teléfono celular de la empresa que utiliza el personal técnico.
#
class TechnicalServiceCorporateCellphone < ApplicationRecord
  belongs_to :corporate_cellphone
  belongs_to :technical_service
end
