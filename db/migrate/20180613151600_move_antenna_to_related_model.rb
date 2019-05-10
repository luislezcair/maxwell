# frozen_string_literal: true

class MoveAntennaToRelatedModel < ActiveRecord::Migration[5.2]
  def change
    create_table :devices do |t|
      t.inet :ip_address
      t.string :model, null: false, default: ''
      t.string :serial_number, null: false, default: ''

      t.integer :ucrm_device_id

      t.timestamps
    end

    remove_column :technical_services, :antenna_serial_number, :string
    remove_column :technical_services, :antenna_model, :string
    remove_column :technical_services, :antenna_ip_address, :inet

    add_column :technical_services, :device_id, :integer
  end
end
