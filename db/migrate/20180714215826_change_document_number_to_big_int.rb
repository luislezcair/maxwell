# frozen_string_literal: true

class ChangeDocumentNumberToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :clients, :document_number, :bigint
  end
end
