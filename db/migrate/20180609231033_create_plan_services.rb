# frozen_string_literal: true

class CreatePlanServices < ActiveRecord::Migration[5.2]
  def change
    create_table :plan_services do |t|
      t.string :name, null: false
      t.integer :ucrm_plan_service_id
      t.timestamps
    end
  end
end
