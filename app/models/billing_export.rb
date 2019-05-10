# frozen_string_literal: true

# Cuando el usuario Contador exporta los servicios técnicos realizos en un
# período determinado y marca estos servicios como facturados, se crea un
# BillingExport con la información de qué servicios se exportaron, qué usuario
# lo hizo y cuál fue el monto total de todos los servicios.
#
class BillingExport < ApplicationRecord
  extend Enumerize

  belongs_to :background_job, optional: true

  has_many :invoices, dependent: :restrict_with_error
  has_many :technical_services, dependent: :nullify

  enumerize :export_type, in: { csv: 0, api: 1 },
                          default: :csv,
                          predicates: true

  attribute :datetime, :datetime, default: -> { Time.current }

  validate :at_least_one_technical_service?
  validate :billed_technical_services?, on: :create
  validate :technical_service_valid_amount?, on: :create

  after_create :create_invoices

  # Crea un BackgroundJob y lo encola para ejecutarse en Sidekiq.
  #
  def perform_sync
    job_id = BillingExportJob.perform_in(2.seconds, id)
    self.background_job = BackgroundJob.create(job_id: job_id, job_item: self)
    save!
  end

  private

  # Una vez guradado el BillingExport se pueden crear las facturas para los
  # servicios técnicos asociados a este BillingExport.
  #
  def create_invoices
    clients_with_ts = technical_services.group_by(&:client)
    days = SystemConfiguration.get_api_config('invoice.expiry_days').to_i
    condition = SystemConfiguration.get('invoice.sale_condition').to_sym

    clients_with_ts.each do |client, services|
      invoice = invoices.build(client: client,
                               emission_date: Time.current,
                               expiry_date: Time.current.advance(days: days),
                               sale_condition: condition,
                               notes: invoice_notes(services))
      invoice.save!
      invoice.create_invoice_items(services)
    end

    self.total_amount = invoices.includes(:invoice_items).sum(:amount)
    save!
  end

  # El campo observaciones de un invoice debe tener Nº de orden, fechas y tipos
  # de trabajos realizados.
  #
  def invoice_notes(services)
    note = ''
    services.each do |s|
      work_types = s.work_types.pluck(:name).join(', ')
      date = I18n.l(s.datetime, format: :short_date)
      opts = { date: date, number: s.work_order_number, work_types: work_types }
      note += I18n.t('invoicing.technical_service.notes', opts) + "\n"
    end
    note
  end

  def at_least_one_technical_service?
    return unless technical_services.empty?

    errors.add(:technical_services, :empty)
  end

  # Comprueba que los servicios técnicos que se vayan a facturar ya no estén
  # facturados o "cerrados".
  # TODO: falta considerar "cerrados".
  #
  def billed_technical_services?
    return if technical_services.all? { |ts| ts.invoice.blank? }

    errors.add(:technical_services, :billed)
  end

  # Comprueba que los servicios técnicos tengan un monto total mayor a $0.
  # Contabilium no permite facturar $0. UCRM sí.
  #
  def technical_service_valid_amount?
    return if technical_services.all? { |ts| ts.total_cost.positive? }

    errors.add(:technical_services, :amount_zero)
  end
end
