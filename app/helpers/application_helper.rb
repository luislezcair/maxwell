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

  # Produce un script que actualiza el historial de navegación. Se utiliza para
  # actualizar la URL de la barra de direcciones del navegador cuando el usuario
  # navega con los enlaces de páginas y ordenamiento de columnas.
  #
  def render_turbolinks_update
    render 'shared/turbolinks_update_history'
  end

  # Crea un scope de forma automática para el modelo actual. Es equivalente a
  # `t('attrib_key', scope: 'activerecord.attributes.technical_service')
  #
  def t_model(key)
    I18n.t(key, scope: "activerecord.attributes.#{controller_name.singularize}")
  end

  # Devuelve un caracter por defecto para indicar que el campo es nulo o está
  # vacío. Para ser utilizado en las vistas.
  #
  def default_on_blank(attribute, options = { default: '-' })
    return options[:default] if attribute.blank?
    attribute
  end
end
