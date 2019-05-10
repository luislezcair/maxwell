# frozen_string_literal: true

class CreateBalancers < ActiveRecord::Migration[5.2]
  def change
    create_table :balancers do |t|
      t.string :name, null: false
      t.timestamps
    end
  end
end
