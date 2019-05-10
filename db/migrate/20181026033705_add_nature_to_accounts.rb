# frozen_string_literal: true

class AddNatureToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :nature, :string, null: false, default: 'patrimonial'
  end
end
