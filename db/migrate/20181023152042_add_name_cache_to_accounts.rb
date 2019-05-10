# frozen_string_literal: true

class AddNameCacheToAccounts < ActiveRecord::Migration[5.2]
  def change
    add_column :accounts, :names_depth_cache, :string, null: false, default: ''
  end
end
