# frozen_string_literal: true

# Concern que crea un Ransacker para buscar y ordenar por nombre completo una
# entidad, cuando el nombre se compone de dos partes: nombre y apellido.
#
module FullNameSearchable
  extend ActiveSupport::Concern

  included do
    ransacker :name do |parent|
      Arel::Nodes::InfixOperation.new('||',
                                      parent.table[:lastname],
                                      parent.table[:firstname])
    end

    def name
      "#{lastname}, #{firstname}"
    end

    def to_label
      name
    end
  end
end
