# frozen_string_literal: true

# Representa una provincia.
#
class Province < ApplicationRecord
  belongs_to :country

  validates :name, presence: true

  scope :sorted, -> { order(:name) }
end
