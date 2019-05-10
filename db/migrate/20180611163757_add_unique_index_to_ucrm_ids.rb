# frozen_string_literal: true

class AddUniqueIndexToUcrmIds < ActiveRecord::Migration[5.2]
  def change
    add_index :clients, :ucrm_id, unique: true
    add_index :plan_services, :ucrm_plan_service_id, unique: true
    add_index :towers, :ucrm_site_id, unique: true
  end
end
