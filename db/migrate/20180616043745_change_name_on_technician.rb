# frozen_string_literal: true

class ChangeNameOnTechnician < ActiveRecord::Migration[5.2]
  def change
    remove_index :technicians, :name

    remove_column :technicians, :name, :string, null: false, default: ''

    add_column :technicians, :firstname, :string, null: false, default: ''
    add_column :technicians, :lastname, :string, null: false, default: ''

    add_index :technicians, [:firstname, :lastname], unique: true
  end
end
