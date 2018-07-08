class Tower < ApplicationRecord
  validates :ucrm_site_id, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
