class TechnicalServiceTechnician < ApplicationRecord
  belongs_to :technical_service
  belongs_to :technician
end
