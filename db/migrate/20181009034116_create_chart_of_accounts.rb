# frozen_string_literal: true

class CreateChartOfAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :code
      t.string :ancestry
      t.boolean :imputable, default: false, null: false
    end

    add_index :accounts, :ancestry
  end
end
