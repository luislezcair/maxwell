# frozen_string_literal: true

def create_corporate_cellphones
  print 'Creating corporate cellphones... '

  CorporateCellphone.find_or_create_by(phone: '375 5243733')
  CorporateCellphone.find_or_create_by(phone: '375 5291199')
  CorporateCellphone.find_or_create_by(phone: '375 5243846')

  puts 'Done.'
end

def create_balancers
  print 'Creating balancers... '

  balancers = [10.1, 10.2, 10.3, 10.4, 11.3, 12.1, 12.2, 12.3, 12.4, 13.1, 14.1,
               15.1, 16.1]
  balancers.each { |b| Balancer.find_or_create_by(name: b) }

  puts 'Done.'
end

def create_technicians
  print 'Creating technicians... '

  Technician.find_or_create_by(firstname: 'Eduardo', lastname: 'Ferreira')
  Technician.find_or_create_by(firstname: 'Cristian', lastname: 'Centurión')
  Technician.find_or_create_by(firstname: 'Claudio', lastname: 'Furstenau')
  Technician.find_or_create_by(firstname: 'Javier Orlando', lastname: 'Kuz')
  Technician.find_or_create_by(firstname: 'Franco Enrique', lastname: 'Gómez')
  Technician.find_or_create_by(firstname: 'Alejandro', lastname: 'González')
  Technician.find_or_create_by(firstname: 'Oscar', lastname: 'Machado')
  Technician.find_or_create_by(firstname: 'Adrián', lastname: 'Tempchuk')
  Technician.find_or_create_by(firstname: 'Karina', lastname: 'Paciello')

  puts 'Done.'
end

def create_cities
  print 'Creating cities... '

  cities = ['Alberdi', 'Alvear', 'Aristóbulo', 'Campo Grande', 'Campo Viera',
            'Corpus', 'Domingo Sabio', 'Dos de Mayo', 'Encantado',
            'Los Helechos', 'Guaraní', 'Oberá', 'San Ignacio', 'Roca',
            'Villa Bonita', 'Santa Rita', '25 de Mayo', 'Cerro Corá',
            'Candelaria'].sort
  cities.each { |c| City.find_or_create_by(name: c) }

  puts 'Done.'
end

def create_transmitters
  print 'Creating transmitters... '

  transmitters = ['2.4 GHz', '3.0 GHz', '5.8 GHz', '900 MHz']
  transmitters.each { |t| Transmitter.find_or_create_by(name: t) }

  puts 'Done.'
end

def create_support_types
  print 'Creating support types... '

  support_types = ['Sin soporte', 'DirectTV', 'Ubiquiti',
                   'Soporte Regulable 1 metro', 'Soporte Alero 1.2 metros',
                   '1 metro', '2 metros', '3 metros', '4 metros', '5 metros',
                   '6 metros', 'Torre del cliente', 'Poste 9 metros',
                   'Poste 12 metros', 'Caño 11 metros'].sort
  support_types.each { |s| SupportType.find_or_create_by(name: s) }

  puts 'Done.'
end

def create_ground_wire_setup_types
  print 'Creating ground wire setup types... '

  types = ['Tiene cable a tierra de la casa',
           'Tiene cable a tierra instalado por 10+ independiente de la casa',
           'No tiene cable a tierra',
           'No se instala por falta de materiales'].sort
  types.each { |t| GroundWireSetupType.find_or_create_by(name: t) }

  puts 'Done.'
end

def create_surge_protector_setup_types
  print 'Creating surge protector setup types... '

  types = ['No tiene',
           'Tiene',
           'Tiene instalado por 10+',
           'No se entrega por falta de stock'].sort
  types.each { |t| SurgeProtectorSetupType.find_or_create_by(name: t) }

  puts 'Done.'
end

def create_work_types
  print 'Creating work types... '

  types = ['Instalación de nuevo cliente', 'Cable a tierra', 'Itinerante',
           'Estabilizador de tensión', 'Extender', 'Router adicional',
           'Instalación de nuevo enlace punto a punto', 'Mudanza', 'Baja',
           'Cat. 2 - Reconfiguración con acceso a domicilio', 'Preventa',
           'Cat. 3 - Complejidad', 'Recableado', 'Cambio de antena',
           'Cambio de router', 'Cambio de servicio',
           'Torre: trabajos en general', 'No factible por obstrucción',
           'No factible por obstrucción parcial',
           'No factible por imposibilidad edilicia',
           'No factible por falta de materiales',
           'No factible por lluvia o mal clima',
           'No factible por cliente ausente'].sort
  types.each { |t| WorkType.find_or_create_by(name: t) }

  puts 'Done.'
end

namespace :seeds do
  desc 'Load initial data for the Technical Service form'

  task initial_data: :environment do
    ActiveRecord::Base.transaction do
      create_balancers
      create_cities
      create_corporate_cellphones
      create_ground_wire_setup_types
      create_support_types
      create_surge_protector_setup_types
      create_technicians
      create_transmitters
      create_work_types
    end
  end
end
