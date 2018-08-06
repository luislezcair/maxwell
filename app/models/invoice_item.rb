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

  before_create :compute_amounts

  after_save :update_invoice_amount
  after_destroy :update_invoice_amount

  private

  # Calcula los campos monto neto y monto IVA y los guarda para no tener que
  # calcularlos cada vez que se necesiten. Contabilium requiere 4 decimales de
  # precisión para calcular correctamente el neto y el IVA. Estos campos tienen
  # 4 decimales de presición. ActiveRecord redondea a 4 decimales antes de
  # guardar el número, así que no es necesario hacerlo acá.
  #
  def compute_amounts
    self.net_amount = amount / (1 + iva_value)
    self.iva_amount = net_amount * iva_value
  end

  # Actualiza el monto total en el Invoice padre.
  #
  def update_invoice_amount
    invoice.update_amount
  end
end
