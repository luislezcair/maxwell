# frozen_string_literal: true

class ChangeClientNumberToInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :clients, :number, :integer, using: 'number::integer', default: nil
  end
end
