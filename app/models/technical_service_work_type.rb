# frozen_string_literal: true

# Representa los trabajos que realizan los técnicos durante un servicio técnico.
#
class TechnicalServiceWorkType < ApplicationRecord
  belongs_to :technical_service
  belongs_to :work_type
end
