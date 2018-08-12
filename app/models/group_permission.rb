# frozen_string_literal: true

# Join table entre Group y Permission. Le asigna un permiso a un grupo con un
# atributo `permission_code` que describe qué acciones puede realizar ese grupo.
# Las acciones son: deny, view, create, edit, edit_delete.
#
class GroupPermission < ApplicationRecord
  extend Enumerize

  belongs_to :group
  belongs_to :permission

  enumerize :permission_code,
            in: { deny: 0, view: 1, create: 2, edit: 3, edit_delete: 4 },
            default: :deny,
            predicates: true

  validates :permission, presence: true

  def self.permission_value(perm)
    permission_code.find_value(perm).value
  end
end
