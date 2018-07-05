class Group < ApplicationRecord
  has_many :users, dependent: :restrict_with_error

  has_many :group_permissions, dependent: :destroy
  has_many :permissions, through: :group_permissions

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  accepts_nested_attributes_for :group_permissions

  after_initialize :create_permissions, if: :new_record?

  private

  # Al crear un nuevo grupo, éste debe tener todos los permisos definidos
  # asociados, así que los agregamos acá, solamente si ya no fueron agregados.
  #
  def create_permissions
    return unless group_permissions.empty?

    Permission.find_each do |p|
      group_permissions.build(permission: p, permission_code: :view)
    end
  end
end
