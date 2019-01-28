# frozen_string_literal: true

# Agregar relación "Cliente tiene un Plan de Servicio"
#
class AddPlanServiceToClients < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :plan_service_id, :integer
  end
end
