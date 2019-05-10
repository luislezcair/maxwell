# frozen_string_literal: true

class AddOrganizationFilterToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :permissions, :organization_filter, :boolean, null: false, default: false
  end
end
