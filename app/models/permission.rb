class Permission < ApplicationRecord
  has_many :group_permissions, dependent: :destroy
  has_many :groups, through: :group_permissions

  validates :code, presence: true
end
