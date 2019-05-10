# frozen_string_literal: true

class AddDateTimeToTechnicalService < ActiveRecord::Migration[5.2]
  def change
    add_column :technical_services, :datetime, :timestamp, null: false
    add_column :technical_services, :technician_id, :integer, null: false
  end
end
