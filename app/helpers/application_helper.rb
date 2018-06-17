# frozen_string_literal: true

# Módulo con helpers utilizados en toda la aplicación.
#
module ApplicationHelper
  # Construye un campo de selección múltiple con checkboxess pero en dos
  # columnas. Asume que usamos bootstrap y simple_form con wrapper
  # horizontal_collection_inline. La clase de asociación utilizada debe
  # implementar un scope `sorted` que ordene la colección.
  #
  def two_column_multiple_choice_for(builder, association, options = {})
    klass = association.to_s.classify.constantize
    options = { required: false, default: nil }.merge(options)

    collection = klass.sorted
    half = collection.count.fdiv(2).ceil
    option_groups = collection.in_groups_of(half, false)

    render 'shared/two_column_multiple_choice', f: builder,
                                                association: association,
                                                required: options[:required],
                                                option_groups: option_groups,
                                                default: options[:default]
  end

  # Busca un método adecuado que devuelva un nombre para mostrar para `object`.
  #
  def display_label_for(object)
    return object.to_label if object.respond_to?(:to_label)
    return object.name if object.respond_to?(:name)
    object.to_s
  end
end
