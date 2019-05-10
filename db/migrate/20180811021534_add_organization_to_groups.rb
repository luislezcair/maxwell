# frozen_string_literal: true

class AddOrganizationToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :organization_id, :integer
  end
end
