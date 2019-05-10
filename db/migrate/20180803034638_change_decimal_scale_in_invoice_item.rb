# frozen_string_literal: true

class ChangeDecimalScaleInInvoiceItem < ActiveRecord::Migration[5.2]
  def change
    change_column :invoice_items, :net_amount, :decimal, precision: 17, scale: 4
    change_column :invoice_items, :iva_amount, :decimal, precision: 17, scale: 4
  end
end
