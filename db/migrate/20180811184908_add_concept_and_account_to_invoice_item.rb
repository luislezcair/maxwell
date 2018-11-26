# frozen_string_literal: true

# Agrega las columnas concept_id y account_code con los valores por defecto que
# estaban en SystemConfiguration y elimina estos registros ya que no se van a
# utilizar más. Ahora está como atributos de Organization.
#
class AddConceptAndAccountToInvoiceItem < ActiveRecord::Migration[5.2]
  def change
    change_table :invoice_items, bulk: true do |t|
      t.integer :concept_id, default: 902_253, null: false
      t.string :account_code, default: '1.1.1', null: false
    end
  end
end
