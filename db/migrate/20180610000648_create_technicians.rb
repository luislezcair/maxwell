# frozen_string_literal: true

class CreateTechnicians < ActiveRecord::Migration[5.2]
  def change
    create_table :technicians do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
