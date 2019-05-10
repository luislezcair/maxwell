# frozen_string_literal: true

class AddUcrmAttributesToTower < ActiveRecord::Migration[5.2]
  def change
    add_column :towers, :address, :string
    add_column :towers, :contact_info, :string
    add_column :towers, :notes, :text
    add_column :towers, :gps_lat, :decimal, null: false, default: 0.0, precision: 15, scale: 12
    add_column :towers, :gps_lon, :decimal, null: false, default: 0.0, precision: 15, scale: 12
  end
end
