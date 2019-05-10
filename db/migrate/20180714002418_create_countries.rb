# frozen_string_literal: true

class CreateCountries < ActiveRecord::Migration[5.2]
  def change
    create_table :countries do |t|
      t.string :name
      t.string :code
      t.integer :contabilium_id
      t.integer :ucrm_id
      t.timestamps

      t.index :name, unique: true
    end
  end
end
