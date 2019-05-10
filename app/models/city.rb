# frozen_string_literal: true

# Representa una ciudad.
#
class City < ApplicationRecord
  belongs_to :province
  has_many :technical_services, dependent: :restrict_with_error

  validates :name, presence: true

  scope :sorted, -> { order(:name) }
end
