# frozen_string_literal: true

# Representa un dispositivo que se utiliza como antena en la instalación de un
# cliente.
#
class Device < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :model, presence: true

  scope :sorted, -> { order(:model) }

  def to_label
    model
  end
end
