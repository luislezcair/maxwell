class TechnicalService < ApplicationRecord
  belongs_to :balancer
  belongs_to :city
  belongs_to :client
  belongs_to :ground_wire_setup_type
  belongs_to :plan_service
  belongs_to :support_type
  belongs_to :surge_protector_setup_type
  belongs_to :technician
  belongs_to :tower
  belongs_to :transmitter

  has_many :technical_service_technicians, dependent: :destroy
  has_many :technicians, through: :technical_service_technicians

  has_many :technical_service_corporate_cellphones, dependent: :destroy
  has_many :corporate_cellphones,
           through: :technical_service_corporate_cellphones

  has_many :technical_service_work_types, dependent: :destroy
  has_many :work_types, through: :technical_service_work_types
end
