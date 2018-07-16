class GroupPermission < ApplicationRecord
  extend Enumerize

  belongs_to :group
  belongs_to :permission

  enumerize :permission_code,
            in: { deny: 0, view: 1, create: 2, edit: 3, edit_delete: 4 },
            default: :deny,
            predicates: true

  validates :permission, presence: true
end
