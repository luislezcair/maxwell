# frozen_string_literal: true

class CreateCorporateCellphones < ActiveRecord::Migration[5.2]
  def change
    create_table :corporate_cellphones do |t|
      t.string :phone, null: false
      t.timestamps
    end
  end
end
