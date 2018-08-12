# frozen_string_literal: true

# Representa un usuario del sistema. Pertenece a un Grupo donde están definidos
# los permisos.
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :rememberable, :trackable, :validatable

  belongs_to :group

  belongs_to :technician, optional: true

  validates :firstname, :lastname, presence: true
  validates :username, presence: true, uniqueness: { case_sensitive: false }

  attr_writer :login

  include FullNameSearchable

  # Permite a un usuario loguearse con su nombre de usuario o su email. El
  # nombre de usuario no es case-sensitive.
  #
  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:login)
    if login
      find_by(['LOWER("users"."username") = :value OR "users"."email" = :value',
               { value: login.downcase }])
    elsif conditions.key?(:username) || conditions.key?(:email)
      find_by(conditions.to_hash)
    end
  end

  def login
    @login || username || email
  end

  # Método llamado por Devise durante el login.
  #
  def active_for_authentication?
    super && active?
  end
end
