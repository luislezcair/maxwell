class TechnicalService < ApplicationRecord
  belongs_to :city
  belongs_to :client
  belongs_to :ground_wire_setup_type
  belongs_to :surge_protector_setup_type
  belongs_to :technician

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

  validates :arrival_time, :datetime, :departure_time, :work_order_number,
            presence: true

  # TODO: activate this when you have finished the form
  # validate :at_least_one_work_type?
  # validate :at_least_one_corporate_cellphone?

  private

  def at_least_one_work_type?
    return unless work_types.empty?
    errors.add(:work_types, :empty_work_types)
  end

  def at_least_one_corporate_cellphone?
    return unless corporate_cellphones.empty?
    errors.add(:corporate_cellphones, :empty_corporate_cellphones)
  end
end
