# frozen_string_literal: true

class AddOrganizationToClient < ActiveRecord::Migration[5.2]
  def change
    add_column :clients, :organization_id, :integer
  end
end
