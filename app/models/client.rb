class Client < ApplicationRecord
  validates :firstname, :lastname, presence: true
  validates :number, presence: true, uniqueness: true

  def name
    "#{lastname}, #{firstname}"
  end

  def to_label
    name
  end
end
