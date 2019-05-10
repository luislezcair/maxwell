# frozen_string_literal: true

class CreateSystemConfiguration < ActiveRecord::Migration[5.2]
  def change
    create_table :system_configurations do |t|
      t.string :name, null: false, default: ''
      t.string :development_value, null: false, default: ''
      t.string :production_value, null: false, default: ''

      t.timestamps
      t.index :name, unique: true
    end
  end
end
