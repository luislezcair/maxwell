# frozen_string_literal: true

class CreateBillingExports < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_exports do |t|
      t.integer :export_type, null: false, default: 0
      t.integer :file_format, null: false, default: 0
      t.datetime :datetime
      t.decimal :total_amount, precision: 15, scale: 2
      t.integer :user_id
      t.timestamps
    end
  end
end
