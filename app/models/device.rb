class Device < ApplicationRecord
  validates :model, presence: true

  scope :sorted, -> { order(:model) }

  def to_label
    model
  end
end
