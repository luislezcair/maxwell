# frozen_string_literal: true

# Clase que representa una Cuenta del Plan de Cuentas. Tiene una estructura de
# árbol para establecer las relaciones jerárquicas del plan utilizando la gema
# Ancestry.
#
class Account < ApplicationRecord
  extend Enumerize

  ORDER = Arel.sql('REPLACE("code", \'.\', \'\')::INTEGER')

  has_ancestry orphan_strategy: :restrict

  enumerize :nature, in: [:patrimonial, :regulator, :result, :order]

  validates :name, :code, presence: true
  validates :code, uniqueness: true,
                   format: { with: /(\d\d{0,1})(\.\d\d{0,1}){0,8}/,
                             allow_blank: false }

  validate :parent_not_imputable
  validate :imputable_with_children, if: :imputable_changed?, on: :update

  before_save :cache_ancestry

  def to_label
    "#{code} - #{name}"
  end

  private

  # Guarda un cache del camino hasta esta cuenta
  #
  def cache_ancestry
    self.names_depth_cache = path.map(&:name).join('/')
  end

  # Valida que esta cuenta no se esté guardando como descendiente de una cuenta
  # imputable.
  #
  def parent_not_imputable
    return unless parent&.imputable

    errors.add(:parent_id, :imputable)
  end

  # Si el atributo imputable se establece en `true`, esta cuenta no debe tener
  # descendientes, de lo contrario devuelve error.
  #
  def imputable_with_children
    return unless imputable && children?

    errors.add(:imputable, :children)
  end
end
