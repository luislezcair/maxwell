# frozen_string_literal: true

class CreateTechnicalServiceWorkTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :technical_service_work_types do |t|
      t.integer :technical_service_id, null: false
      t.integer :work_type_id, null: false

      t.index [:technical_service_id, :work_type_id],
              unique: true,
              name: 'technical_service_work_type_unique'
    end
  end
end
