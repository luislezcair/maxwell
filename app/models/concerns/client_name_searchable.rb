# frozen_string_literal: true

# Concern que crea un Ransacker para buscar y ordenar por nombre completo un
# cliente, cuyo nombre puede estar compuesto por dos campo: lastname y firstname
# o ser company_name si se trata de una empresa.
# Además, agrega un scope para ordenar, un método para devolver apeliido y
# nombre separados por una coma y un método to_label para mostrar el nombre en
# formularios.
#
module ClientNameSearchable
  extend ActiveSupport::Concern

  SORT_SQL = 'CASE WHEN "clients"."client_type" = 0 THEN '\
             '"clients"."lastname" || "clients"."firstname" ELSE '\
             '"clients"."company_name" END'

  included do
    ransacker :name do
      Arel.sql(SORT_SQL)
    end

    # Convierte a string el númeró de cliente y el documento para poder usarlo
    # en las búsquedas.
    ransacker :document_number_s do
      Arel.sql('"document_number"::varchar')
    end

    ransacker :number_s do
      Arel.sql('"number"::varchar')
    end

    ransack_alias :identification, :name_or_document_number_s_or_number_s

    scope :sorted, -> { order(Arel.sql("#{SORT_SQL} ASC")) }

    # Define el nombre para mostrar. Si es una persona se usa nombre y apellido,
    # si es una empresa de usa company_name.
    #
    def name
      if person?
        "#{lastname}, #{firstname}"
      else
        company_name
      end
    end

    def to_label
      name
    end
  end
end
