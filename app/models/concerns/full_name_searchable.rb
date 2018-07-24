# frozen_string_literal: true

# Concern que crea un Ransacker para buscar y ordenar por nombre completo una
# entidad, cuando el nombre se compone de dos partes: nombre y apellido.
# Además, agrega un scope para ordenar, un método para devolver apeliido y
# nombre separados por una coma y un método to_label para mostrar el nombre en
# formularios.
#
module FullNameSearchable
  extend ActiveSupport::Concern

  included do
    ransacker :name do |parent|
      Arel::Nodes::InfixOperation.new('||',
                                      parent.table[:lastname],
                                      parent.table[:firstname])
    end

    scope :sorted, -> { order(Arel.sql('"lastname", "firstname" ASC')) }

    def name
      "#{lastname}, #{firstname}"
    end

    def to_label
      name
    end
  end
end
