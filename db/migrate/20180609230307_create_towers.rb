# frozen_string_literal: true

class CreateTowers < ActiveRecord::Migration[5.2]
  def change
    create_table :towers do |t|
      t.string :name, null: false
      t.integer :ucrm_site_id
      t.timestamps
    end
  end
end
