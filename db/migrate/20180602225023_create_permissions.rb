# frozen_string_literal: true

class CreatePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :permissions do |t|
      t.string :title
      t.string :category
      t.string :code

      t.boolean :view
      t.boolean :manage
      t.boolean :deny

      t.timestamps
    end
  end
end
