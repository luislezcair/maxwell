# frozen_string_literal: true

# Relación entre Técnico y Servicio Técnico. Representa los técnicos que
# realizan un servicio técnico.
#
class TechnicalServiceTechnician < ApplicationRecord
  belongs_to :technical_service
  belongs_to :technician
end
