# frozen_string_literal: true

class AddUserToTechnicalService < ActiveRecord::Migration[5.2]
  def change
    add_column :technical_services, :user_id, :integer
  end
end
