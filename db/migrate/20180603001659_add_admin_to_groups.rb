# frozen_string_literal: true

class AddAdminToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :admin, :boolean, null: false, default: false
  end
end
