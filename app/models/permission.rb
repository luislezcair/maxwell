# frozen_string_literal: true

# Representa un permiso del sistema. Los permisos se asignan a grupos en el
# join model GroupPermission.
# Un Permission tiene un título y categoría para mostrar en la interfaz y
# clasificarlos y un atributo `code` que contiene el nombre del modelo al que
# hace referencia.
#
# Por ejemplo: un Permission con code 'technical_service' indica que se trata
# del modelo TechnicalService y en GroupPermission se le asigna las acciones
# que puede realizar un grupo sobre ese modelo, como : deny, view, create, etc.
#
class Permission < ApplicationRecord
  has_many :group_permissions, dependent: :destroy
  has_many :groups, through: :group_permissions

  validates :code, presence: true

  after_create :add_to_groups

  # Cada vez que se crea un nuevo permiso hay que agregarlo a todos los grupos,
  # excepto a los administradores, con la habilidad `deny` por defecto.
  #
  def add_to_groups
    Group.where(admin: false).find_each do |g|
      gp = g.group_permissions.build(permission: self, permission_code: :deny)
      gp.save!
    end
  end
end
