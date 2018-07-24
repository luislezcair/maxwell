# frozen_string_literal: true

# Representa un ítem de una factura (Invoice).
#
class InvoiceItem < ApplicationRecord
  extend Enumerize

  belongs_to :invoice
  has_one :technical_service, dependent: :nullify

  enumerize :iva, in: { iva_0: 0.0,
                        iva_2_5: 0.025,
                        iva_5: 0.05,
                        iva_10: 0.105,
                        iva_21: 0.21,
                        iva_27: 0.27 },
                  default: :iva_21,
                  scope: true

  # Shorthand para consultar el monto de IVA correspondiente para el token iva.
  #
  def self.iva_value_for(iva)
    iva.find_value(iva).value
  end
end
