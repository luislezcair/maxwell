# frozen_string_literal: true

class AddTotalAmountToTechnicalService < ActiveRecord::Migration[5.2]
  def change
    add_column :technical_services,
               :total_cost,
               :decimal,
               precision: 15,
               scale: 2,
               null: false,
               default: 0.0
  end
end
