class PlanService < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
