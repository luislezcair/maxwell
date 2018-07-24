# frozen_string_literal: true

# Representa un servicio técnico realizado a un cliente. Los costos de mano de
# obra (labour_cost) y de equipos (equipment_cost) se utilizan para facturar a
# los clientes.
#
class TechnicalService < ApplicationRecord
  belongs_to :city
  belongs_to :client
  belongs_to :ground_wire_setup_type
  belongs_to :surge_protector_setup_type

  belongs_to :balancer, optional: true
  belongs_to :device, optional: true
  belongs_to :plan_service, optional: true
  belongs_to :support_type, optional: true
  belongs_to :tower, optional: true
  belongs_to :transmitter, optional: true

  # Invoicing:
  belongs_to :billing_export, optional: true
  belongs_to :invoice, optional: true
  belongs_to :invoice_item, optional: true

  has_many :technical_service_technicians, dependent: :destroy
  has_many :technicians, through: :technical_service_technicians

  has_many :technical_service_corporate_cellphones, dependent: :destroy
  has_many :corporate_cellphones,
           through: :technical_service_corporate_cellphones

  has_many :technical_service_work_types, dependent: :destroy
  has_many :work_types, through: :technical_service_work_types

  attribute :datetime, :datetime, default: -> { Time.current }

  validates :arrival_time, :datetime, :departure_time, :work_order_number,
            presence: true

  validates :work_order_number, :plug_adapter_quantity,
            numericality: { less_than: 2**30 }

  validate :at_least_one_corporate_cellphone?
  validate :at_least_one_technician?
  validate :at_least_one_work_type?
  validate :client_is_synced

  before_save :compute_total_cost

  # Los servicios técnicos no facturados son aquellos que no tienen una factura
  # asociada.
  #
  def self.not_billed
    where(invoice: nil)
  end

  # Devuelve una descripción de este servicio técnico para utilizarse en la
  # facturación.
  #
  def description
    date = I18n.l(datetime, format: :short_date)
    I18n.t('invoicing.technical_service', date: date, count: 1)
  end

  private

  def at_least_one_corporate_cellphone?
    return unless corporate_cellphones.empty?
    errors.add(:corporate_cellphones, :empty_corporate_cellphones)
  end

  def at_least_one_technician?
    return unless technicians.empty?
    errors.add(:technicians, :empty_technicians)
  end

  def at_least_one_work_type?
    return unless work_types.empty?
    errors.add(:work_types, :empty_work_types)
  end

  def client_is_synced
    return if client&.synced?
    errors.add(:client, :not_synced)
  end

  # Suma los costos de mano de obra y equipos y los guarda en el campo de costo
  # total
  #
  def compute_total_cost
    self.total_cost = labour_cost + equipment_cost
  end
end
