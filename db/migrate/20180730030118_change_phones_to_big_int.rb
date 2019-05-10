# frozen_string_literal: true

class ChangePhonesToBigInt < ActiveRecord::Migration[5.2]
  def change
    change_column :corporate_cellphones, :phone, :bigint, using: '"phone"::BIGINT'
  end
end
