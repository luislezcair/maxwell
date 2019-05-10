# frozen_string_literal: true

class AddActiveFieldToTechnician < ActiveRecord::Migration[5.2]
  def change
    add_column :technicians, :active, :boolean, default: true, null: false
  end
end
