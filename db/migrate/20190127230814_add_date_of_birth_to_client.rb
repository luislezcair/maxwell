# frozen_string_literal: true

class AddDateOfBirthToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :date_of_birth, :date
  end
end
