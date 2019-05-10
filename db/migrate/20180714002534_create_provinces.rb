# frozen_string_literal: true

class CreateProvinces < ActiveRecord::Migration[5.2]
  def change
    create_table :provinces do |t|
      t.integer :country_id
      t.string :name
      t.integer :contabilium_id
      t.integer :ucrm_id
      t.timestamps
    end
  end
end
