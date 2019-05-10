# frozen_string_literal: true

class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, default: '', null: false
      t.string :account_code, default: '', null: false
      t.integer :concept_id, default: 0, null: false

      t.timestamps
    end
  end
end
