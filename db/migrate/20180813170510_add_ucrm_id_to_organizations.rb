# frozen_string_literal: true

class AddUcrmIdToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :ucrm_id, :integer
  end
end
