class Client < ApplicationRecord
  has_many :technical_services, dependent: :restrict_with_error

  validates :firstname, :lastname, presence: true
  validates :number, presence: true, uniqueness: true

  include FullNameSearchable
end
