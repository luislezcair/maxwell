# frozen_string_literal: true

def update_maxwell_model(mmodel, umodel)
  print "Updating #{mmodel.class.name} with #{umodel.api_name} ID: "\
        "#{umodel.id}..."
  mmodel.update(umodel.maxwell_model_attributes)
  puts 'Done.'
end

def create_maxwell_model(umodel)
  print "Creating #{umodel.klass.name} with #{umodel.api_name} ID: "\
        "#{umodel.id}..."
  m = umodel.to_maxwell_model

  if m.valid?
    m.save!
    puts 'Done.'
  else
    puts 'SKIPPING INVALID MODEL.'
  end
end

# Busca el modelo pasado como parámetro a tráves del ucrm_id. Si lo encuentra
# actualiza los atributos y, si no lo encuentra, lo crea.
#
def update_or_create_maxwell_model(model)
  t = model.maxwell_model

  if t
    update_maxwell_model(t, model)
  else
    create_maxwell_model(model)
  end
end

# Obtiene todos las entidades consultando a la API y llama al método para
# actualizar o crearlos.
#
def update_or_create_all(collection)
  collection.each do |u|
    update_or_create_maxwell_model(u)
  end
end

def single_request_strategy(collection)
  ActiveRecord::Base.transaction do
    update_or_create_all(collection)
  end
end

# Consulta la primera página de la colección para obtener los primeros
# resultados y la información sobre el total de elementos y la cantidad por
# cada página. Con esto calcula el total de páginas y luego consulta las
# páginas restantes.
#
def multiple_request_strategy(klass)
  page = 1
  collection = klass.collection(page)

  total = collection.metadata[:total]
  per_page = collection.metadata[:count]
  total_pages = total.fdiv(per_page).ceil

  ActiveRecord::Base.transaction do
    puts "Creating first #{per_page} #{klass.model_name.collection}. "\
         "Total pages: #{total_pages}."
    update_or_create_all(collection)

    while page < total_pages
      page += 1
      collection = klass.collection(page)

      puts "Creating #{collection.metadata[:count]} "\
           "#{klass.model_name.collection} on page #{page}."
      update_or_create_all(collection)
    end
  end
end

namespace :apis do
  desc 'Sync entities from an API endpoint to Maxwell'

  # Esta tarea toma un parámetro que es el nombre de clase de la entidad que se
  # va a sincronizar. Ej: $ rake ucrm:sync[UCRM::Device]
  task :sync, [:model] => [:environment] do |_task, args|
    klass = args[:model].constantize

    # Los modelos de Contabilium tienen un método especial para obtener la
    # colección de objetos porque usan parámetros y rutas particulares y están
    # paginados.
    # Si están paginados se consulta cada página.
    if klass.pageable?
      multiple_request_strategy(klass)
    else
      collection = if klass.respond_to?(:collection)
                     klass.collection
                   else
                     klass.all
                   end
      single_request_strategy(collection)
    end
  end
end
