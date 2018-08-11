# frozen_string_literal: true

# Agrega las columnas concept_id y account_code con los valores por defecto que
# estaban en SystemConfiguration y elimina estos registros ya que no se van a
# utilizar más. Ahora está como atributos de Organization.
#
class AddConceptAndAccountToInvoiceItem < ActiveRecord::Migration[5.2]
  def change
    change_table :invoice_items, bulk: true do |t|
      concept = SystemConfiguration.get_api_config('invoice.concept_id').to_i
      code = SystemConfiguration.get_api_config('invoice.account_code')

      t.integer :concept_id, default: concept, null: false
      t.string :account_code, default: code, null: false

      SystemConfiguration.find_by(name: 'invoice.concept_id').destroy
      SystemConfiguration.find_by(name: 'invoice.account_code').destroy
    end
  end
end
