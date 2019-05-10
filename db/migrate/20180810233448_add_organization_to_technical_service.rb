# frozen_string_literal: true

class AddOrganizationToTechnicalService < ActiveRecord::Migration[5.2]
  def change
    add_column :technical_services, :organization_id, :integer, default: 1
  end
end
