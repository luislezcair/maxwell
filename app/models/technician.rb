class Technician < ApplicationRecord
  has_many :technical_service_technicians, dependent: :restrict_with_error

  validates :firstname, :lastname, presence: true
  validates :firstname, uniqueness: { scope: [:lastname],
                                      case_sensitive: false }

  scope :sorted, -> { order('lastname, firstname ASC') }

  def name
    "#{lastname}, #{firstname}"
  end

  def to_label
    name
  end
end
