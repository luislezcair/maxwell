# frozen_string_literal: true

class ChangeUserNameToFirstAndLastName < ActiveRecord::Migration[5.2]
  def change
    remove_index :users, :name

    remove_column :users, :name, :string

    add_column :users, :firstname, :string, null: false, default: ''
    add_column :users, :lastname, :string, null: false, default: ''
  end
end
