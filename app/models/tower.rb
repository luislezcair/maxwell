class Tower < ApplicationRecord
  validates :name, :ucrm_site_id, presence: true
end
