class Client < ApplicationRecord
  validates :firstname, :lastname, presence: true
  validates :number, presence: true, uniqueness: true

  ransacker :name do |parent|
    Arel::Nodes::InfixOperation.new('||',
                                    parent.table[:lastname],
                                    parent.table[:firstname])
  end

  def name
    "#{lastname}, #{firstname}"
  end

  def to_label
    name
  end
end
