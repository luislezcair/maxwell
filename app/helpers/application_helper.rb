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
    options = { required: false, default: nil, collection: klass.sorted }
              .merge(options)

    collection = options[:collection]
    half = collection.count.fdiv(2).ceil
    option_groups = half.positive? ? collection.in_groups_of(half, false) : []

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

  # YOLO: Crea un scope para no tener que escribirlo cada vez que hay que
  # traducir un atributo, cuando t_model no sirve.
  #
  def t_attrib(key)
    I18n.t(key, scope: 'activerecord.attributes')
  end

  # Crea un scope de forma automática para la vista actual. Es equivalente a
  # `t('attrib_key', scope: 'technical_services.index')
  #
  def t_view(key)
    I18n.t(key, scope: "#{controller_name}.#{action_name}")
  end

  # Devuelve un caracter por defecto para indicar que el campo es nulo o está
  # vacío. Para ser utilizado en las vistas.
  #
  def default_on_blank(attribute, options = { default: '-' })
    return options[:default] if attribute.blank?

    attribute
  end

  # Traduce valores true y false a Sí y No, respectivamente.
  #
  def boolean_display(value)
    return I18n.t('boolean.byes') if value

    I18n.t('boolean.bno')
  end

  # Llama al URL helper pasado como argumento y le agrega los parámetros de
  # paginación y búsqueda. Se utiliza para que los botones de eliminar mantengan
  # la vista de la tabla en la página actual con los filtros actuales.
  #
  def path_with_parameters(path, args)
    page = request.path_parameters[:page]
    q = request.query_parameters[:q]
    method(path).call(args, page: page, q: q)
  end

  # Construye una ruta llamando al helper `path` con los argumentos `args` y
  # le agrega un parámetro `return_to` para que la acción que lo reciba redirija
  # a la URL `return_url` con los parámetros de Ransack actuales.
  #
  def path_with_return_to(path, args, return_url)
    return_to = method(return_url).call(q: request.query_parameters[:q])
    method(path).call(args, return_to: return_to)
  end

  # Agrupa los permisos por categoría para mostrarlos en el formulario de Grupos
  # y ordena alfabéticamente las categorías y los permisos dentro de cada
  # categoría.
  #
  def permissions_by_category(group)
    group.group_permissions
         .group_by { |gp| gp.permission.category }
         .sort
         .map { |cat, perms| [cat, perms.sort_by { |p| p.permission.title }] }
  end

  # Devuelve una URL para volver atrás en la vista de detalles de una entidad
  # manteniendo los parámetros de búsqueda si es que existen en el referer
  # cuando la visita viene desde la vista index.
  # Si la visita no viene desde index o no hay referer, se devuelve la URL al
  # index sin ningún parámetro.
  #
  def back_link_for(helper_url)
    if !request.referer&.starts_with?(helper_url) ||
       request.referer.match(%r{\/[0-9]+\/edit$|\/new$})
      helper_url
    else
      request.referer
    end
  end

  def app_name
    SystemConfiguration.get('application.name', DEFAULT_APP_NAME)
  end

  def app_description
    SystemConfiguration.get('application.description', DEFAULT_APP_DESCRIPTION)
  end

  def app_website_url
    SystemConfiguration.get('application.website', DEFAULT_APP_WEBSITE)
  end
end
