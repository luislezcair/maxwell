# frozen_string_literal: true

class AddUniquenessToModels < ActiveRecord::Migration[5.2]
  def change
    add_index :balancers, :name, unique: true
    add_index :cities, :name, unique: true
    add_index :corporate_cellphones, :phone, unique: true
    add_index :ground_wire_setup_types, :name, unique: true
    add_index :groups, :name, unique: true
    add_index :plan_services, :name, unique: true
    add_index :support_types, :name, unique: true
    add_index :surge_protector_setup_types, :name, unique: true
    add_index :technicians, :name, unique: true
    add_index :towers, :name, unique: true
    add_index :transmitters, :name, unique: true
    add_index :users, :name, unique: true
    add_index :work_types, :name, unique: true
  end
end
