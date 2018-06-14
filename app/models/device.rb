class Device < ApplicationRecord
  validates :model, presence: true
end
