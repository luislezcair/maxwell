# frozen_string_literal: true

class ChangePermissions < ActiveRecord::Migration[5.2]
  def change
    remove_column :permissions, :view, :boolean
    remove_column :permissions, :manage, :boolean
    remove_column :permissions, :deny, :boolean

    add_column :permissions, :permission, :integer, null: false, default: 0
  end
end
