class Client < ApplicationRecord
  validates :firstname, :lastname, :number, presence: true
end
