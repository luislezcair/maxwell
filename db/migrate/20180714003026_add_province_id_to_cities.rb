# frozen_string_literal: true

class AddProvinceIdToCities < ActiveRecord::Migration[5.2]
  def change
    add_column :cities, :province_id, :integer
    add_column :cities, :ucrm_id, :integer
    add_column :cities, :contabilium_id, :integer

    remove_index :cities, :name
  end
end
