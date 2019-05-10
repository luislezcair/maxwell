# frozen_string_literal: true

class CreateSupportTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :support_types do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
