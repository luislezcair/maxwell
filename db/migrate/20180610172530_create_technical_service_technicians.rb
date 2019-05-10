# frozen_string_literal: true

class CreateTechnicalServiceTechnicians < ActiveRecord::Migration[5.2]
  def change
    create_table :technical_service_technicians do |t|
      t.integer :technical_service_id, null: false
      t.integer :technician_id, null: false

      t.index [:technical_service_id, :technician_id],
              unique: true,
              name: 'technical_service_technician_unique'
    end
  end
end
