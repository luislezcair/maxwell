# frozen_string_literal: true

class AddFieldsToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :mode, :integer, null: false, default: 0

    add_column :invoice_items, :net_amount, :decimal, precision: 15, scale: 2, default: 0.0, null: false
    add_column :invoice_items, :iva_amount, :decimal, precision: 15, scale: 2, default: 0.0, null: false
    change_column_default :invoice_items, :iva, from: 0.0, to: 0.21
  end
end
