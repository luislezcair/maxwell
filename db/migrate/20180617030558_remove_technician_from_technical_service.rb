class RemoveTechnicianFromTechnicalService < ActiveRecord::Migration[5.2]
  def change
    remove_column :technical_services, :technician_id, :integer
  end
end
