# frozen_string_literal: true

class AddCustomActionsToPermissions < ActiveRecord::Migration[5.2]
  def change
    add_column :permissions, :custom_actions, :text
  end
end
