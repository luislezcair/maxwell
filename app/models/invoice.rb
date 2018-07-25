# frozen_string_literal: true

# Representa un comprobante: factura, recibo, nota o cotización.
# Se sincroniza con Contabilium y UCRM.
#
class Invoice < ApplicationRecord
  extend Enumerize

  belongs_to :billing_export
  belongs_to :client

  has_many :invoice_items, dependent: :destroy
  has_many :technical_services, dependent: :nullify

  enumerize :voucher_type, in: { factura_a: 0, factura_b: 1, factura_c: 2,
                                 ndebito_a: 3, ndebito_b: 4, ndebito_c: 5,
                                 ncredito_a: 6, ncredito_b: 7, ncredito_c: 8,
                                 cotizacion: 9 },
                           default: :cotizacion,
                           predicates: true

  enumerize :sale_condition, in: { efectivo: 0, cheque: 1, cta_cte: 2, pay_u: 3,
                                   mercado_pago: 4, debito: 5, credito: 6,
                                   ticket: 7, otro: 8 },
                             default: :efectivo,
                             predicates: true

  scope :not_synced_contabilium, -> { where(contabilium_id: nil) }
  scope :not_synced_ucrm, -> { where(ucrm_id: nil) }

  # Crea los InvoiceItems para esta factura con los datos de cada servicio
  # técnico en `services` y asigna al servicio este Invoice para indicar que ya
  # está facturado.
  #
  def create_invoice_items(services)
    services.each do |s|
      item = invoice_items.build(description: s.description,
                                 amount: s.total_cost)
      item.save!

      s.invoice = self
      s.invoice_item = item
      s.save!
    end
  end

  # Devuelve el monto neto de la factura para los ítems con IVA de 21%
  #
  def net_21
    net_amount_for_iva(:iva_21)
  end

  # Devuelve el monto que corresponde al 21% del IVA.
  #
  def iva_21
    net_21 * InvoiceItem.iva_value_for(iva)
  end

  private

  # Devuelve el monto neto para el porcentaje de IVA pasado como parámetro.
  #
  def net_amount_for_iva(iva)
    divider = InvoiceItem.iva_value_for(iva) + 1
    invoice_items.with_iva(iva).sum(:amount) / divider
  end
end