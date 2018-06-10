class PlanService < ApplicationRecord
  validates :name, presence: true
end
