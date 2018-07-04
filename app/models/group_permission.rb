class GroupPermission < ApplicationRecord
  belongs_to :group
  belongs_to :permission

  enum permission_code: [:deny, :view, :edit, :edit_delete]

  validates :permission, presence: true
end
