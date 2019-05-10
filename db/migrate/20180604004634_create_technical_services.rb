# frozen_string_literal: true

class CreateTechnicalServices < ActiveRecord::Migration[5.2]
  def change
    create_table :technical_services do |t|
      t.integer :work_order_number, null: false, default: 0

      t.string :antenna_serial_number
      t.string :antenna_model
      t.inet :antenna_ip_address

      t.string :router_model
      t.string :router_serial_number

      t.string :wifi_ssid
      t.string :wifi_password

      t.decimal :cable_length, precision: 15, scale: 2, null: false, default: 0.0
      t.integer :plug_adapter_quantity, null: false, default: 0

      t.time :arrival_time
      t.time :departure_time

      t.string :google_maps_url

      t.decimal :labour_cost, precision: 15, scale: 2, null: false, default: 0.0
      t.decimal :equipment_cost, precision: 15, scale: 2, null: false, default: 0.0

      t.string :observations

      t.timestamps
    end
  end
end
