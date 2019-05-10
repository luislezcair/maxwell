# frozen_string_literal: true

class AddFieldsToClient < ActiveRecord::Migration[5.2]
  def change
    change_table :clients do |t|
      t.string :company_name
      t.integer :iva_condition, default: 0, null: false # enum
      t.integer :client_type, default: 0, null: false # enum
      t.integer :document_type, default: 0, null: false # enum
      t.integer :document_number
      t.string :phone
      t.string :email
      t.integer :country_id
      t.integer :province_id
      t.integer :city_id
      t.string :address
      t.string :floor_dept
      t.text :notes
    end
  end
end
