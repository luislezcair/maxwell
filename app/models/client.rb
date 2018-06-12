class Client < ApplicationRecord
  validates :firstname, :lastname, presence: true
  validates :number, presence: true, uniqueness: true
end
