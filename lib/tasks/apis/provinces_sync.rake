# frozen_string_literal: true

namespace :apis do
  desc 'For each Country, try to get and save all the provinces'

  task contab_provinces: :environment do
    # countries = Country.where.not(contabilium_id: nil)
    # Por ahora solamente para Argetina. Contabilium no tiene otras provincias
    # cargadas.
    countries = Country.where(code: 'AR')

    ActiveRecord::Base.transaction do
      countries.find_each do |cc|
        print "Obtaining provinces for #{cc.name}..."

        cps = Contab::Province.collection(cc.contabilium_id)

        cps.each do |cp|
          p = cp.to_maxwell_model
          p.country_id = cc.id
          p.save!
        end

        puts "Saved #{cps.count} provinces."
      end
    end
  end
end
