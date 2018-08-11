# frozen_string_literal: true

# Representa un comprobante: factura, recibo, nota o cotización.
# Se sincroniza con Contabilium y UCRM.
#
class Invoice < ApplicationRecord
  extend Enumerize

  belongs_to :billing_export
  belongs_to :client

  has_one :background_job, as: :job_item, dependent: :nullify

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
                             default: :cta_cte,
                             predicates: true

  enumerize :mode, in: { other: 0, electronic: 1, checkbook: 2 },
                   default: :other

  scope :not_synced_contabilium, -> { where(contabilium_id: nil) }
  scope :not_synced_ucrm, -> { where(ucrm_id: nil) }

  # Devuelve true solamente si este Invoice se sincronizó con ambos sistemas
  # externos.
  #
  def synced?
    contabilium_id.present? && ucrm_id.present?
  end

  # Crea los InvoiceItems para esta factura con los datos de cada servicio
  # técnico en `services` y asigna al servicio este Invoice para indicar que ya
  # está facturado.
  #
  def create_invoice_items(services)
    services.each do |s|
      org = s.organization
      item = invoice_items.build(account_code: org.account_code,
                                 amount: s.total_cost,
                                 concept_id: org.concept_id,
                                 description: s.description)
      item.save!

      s.invoice = self
      s.invoice_item = item
      s.save!(context: :invoicing)
    end
  end

  # Este método es llamado por InvoiceItem en `after_save` para actualizar el
  # monto total de la factura con la suma de los ítems. Se lo llama cada vez
  # que se crea y se destruye un ítem. Se lo guarda acá para evitar calcularlo
  # cada vez que se necesite.
  #
  def update_amount
    self.total_amount = invoice_items.sum(:amount)
    save!
  end

  # Devuelve el monto neto total de este comprobante sumando los netos de los
  # ítems.
  #
  def net_amount
    invoice_items.sum(:net_amount)
  end

  # Devuelve el monto de IVA total de este comprobante. Por ahora es siempre
  # el IVA 21%.
  #
  def iva_amount
    invoice_items.sum(:iva_amount)
  end

  # Crea un BackgroundJob y lo encola para ejecutarse en Sidekiq.
  #
  def perform_sync
    job_id = InvoiceSyncJob.perform_in(2.seconds, id)
    BackgroundJob.create(job_id: job_id, job_item: self)
  end
end
