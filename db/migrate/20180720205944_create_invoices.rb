# frozen_string_literal: true

class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.integer :client_id
      t.integer :billing_export_id
      t.integer :voucher_type, null: false, default: 9
      t.integer :sale_condition, null: false, default: 0
      t.integer :sale_point, null: false, default: 4
      t.datetime :emission_date
      t.datetime :expiry_date
      t.text :notes, null: '', default: ''

      t.integer :contabilium_id
      t.integer :ucrm_id

      t.timestamps
    end

    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :quantity, default: 1, null: false
      t.decimal :iva, null: false, default: 0.0
      t.decimal :amount, precision: 15, scale: 2, default: 0.0, null: false
      t.decimal :discount, precision: 15, scale: 2, default: 0.0, null: false
      t.string :description, default: '', null: false

      t.integer :contaibilium_id
      t.integer :ucrm_id

      t.timestamps
    end
  end
end
