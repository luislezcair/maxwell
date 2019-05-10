# frozen_string_literal: true

# Representa un país.
#
class Country < ApplicationRecord
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  scope :sorted, -> { order(:name) }
end
