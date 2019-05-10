# frozen_string_literal: true

class AddInvoicingToTechnicalServices < ActiveRecord::Migration[5.2]
  def change
    change_table :technical_services, bulk: true do |t|
      t.integer :billing_export_id
      t.integer :invoice_item_id
      t.integer :invoice_id
    end
  end
end
