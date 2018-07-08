class SurgeProtectorSetupType < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
