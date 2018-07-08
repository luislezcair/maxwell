# frozen_string_literal: true

# Busca el modelo pasado como parámetro a tráves del ucrm_id. Si lo encuentra
# actualiza los atributos y, si no lo encuentra, lo crea.
#
def update_or_create_maxwell_model(model)
  t = model.maxwell_model

  if t
    print "Updating #{t.class.name} with UCRM ID: #{model.id}..."
    t.update(model.maxwell_model_attributes)
  else
    print "Creating #{model.klass.name} with UCRM ID: #{model.id}..."
    m = model.to_maxwell_model
    if m.valid?
      m.save!
      puts 'Done.'
    else
      puts 'SKIPPING INVALID MODEL.'
    end
  end
end

# Obtiene todos las entidades consultando a la API de UCRM y llama al método
# para actualizar o crearlos.
#
def update_or_create_all(ucrm_class)
  ucrm_class.all.each do |u|
    update_or_create_maxwell_model(u)
  end
end

namespace :ucrm do
  desc 'Sync entities from UCRM to Maxwell'

  task sync: :environment do
    ucrm_classes = [UCRM::Site, UCRM::Device, UCRM::ServicePlan, UCRM::Client]

    ActiveRecord::Base.transaction do
      ucrm_classes.each { |uc| update_or_create_all(uc) }
    end
  end
end
