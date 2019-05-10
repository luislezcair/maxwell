# frozen_string_literal: true

class AddTotalAmountToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :total_amount, :decimal, precision: 15, scale: 2, null: false, default: 0.0
  end
end
