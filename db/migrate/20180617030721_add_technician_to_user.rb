# frozen_string_literal: true

class AddTechnicianToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :technician_id, :integer
  end
end
