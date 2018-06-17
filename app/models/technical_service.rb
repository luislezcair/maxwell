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
end
