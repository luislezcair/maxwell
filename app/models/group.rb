class Group < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  has_many :group_permissions, dependent: :destroy
  has_many :permissions, through: :group_permissions

  validates :name, presence: true, uniqueness: { case_sensitive: false }
end
