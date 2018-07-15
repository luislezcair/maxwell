# frozen_string_literal: true

namespace :apis do
  desc 'For each Province, try to get and save all the cities'

  task contab_cities: :environment do
    # Por ahora cargamos solamente las ciudades de Misiones. Contabilium tiene
    # cargadas más de 500 ciudades para Misiones. Para todas las provincias
    # son más de 20k y sobrepasa los límitis de Heroku.
    # provinces = Province.where.not(contabilium_id: nil)
    provinces = Province.where(contabilium_id: 14)

    ActiveRecord::Base.transaction do
      provinces.find_each do |pp|
        print "Obtaining cities for #{pp.name}..."

        ccs = Contab::City.collection(pp.contabilium_id)

        ccs.each do |cc|
          next if cc.Nombre.blank?

          c = cc.to_maxwell_model
          c.name = c.name.titleize
          c.province_id = pp.id
          c.save!
        end

        puts "Saved #{ccs.count} cities."
      end
    end
  end
end
