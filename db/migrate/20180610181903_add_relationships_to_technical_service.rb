# frozen_string_literal: true

class AddRelationshipsToTechnicalService < ActiveRecord::Migration[5.2]
  def change
    change_table :technical_services do |t|
      t.integer :city_id
      t.integer :client_id
      t.integer :tower_id
      t.integer :transmitter_id
      t.integer :balancer_id
      t.integer :support_type_id
      t.integer :plan_service_id
      t.integer :ground_wire_setup_type_id
      t.integer :surge_protector_setup_type_id
    end
  end
end
