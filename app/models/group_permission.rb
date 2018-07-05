class GroupPermission < ApplicationRecord
  extend Enumerize

  belongs_to :group
  belongs_to :permission

  enumerize :permission_code, in: { deny: 0, view: 1, edit: 2, edit_delete: 3 },
                              default: :deny,
                              predicates: true

  validates :permission, presence: true
end
