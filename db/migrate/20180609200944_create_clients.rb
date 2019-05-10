# frozen_string_literal: true

class CreateClients < ActiveRecord::Migration[5.2]
  def change
    create_table :clients do |t|
      t.string :firstname, null: false, default: ''
      t.string :lastname, null: false, default: ''

      t.string :number, null: false, default: ''

      t.integer :ucrm_id
      t.integer :contabilium_id

      t.timestamps
    end
  end
end
