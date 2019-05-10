# frozen_string_literal: true

class CreateTechnicalServiceCorporateCellphones < ActiveRecord::Migration[5.2]
  def change
    create_table :technical_service_corporate_cellphones do |t|
      t.integer :technical_service_id, null: false
      t.integer :corporate_cellphone_id, null: false

      t.index [:technical_service_id, :corporate_cellphone_id],
              unique: true,
              name: 'technical_service_corporate_cellphone_unique'
    end
  end
end
