# frozen_string_literal: true

namespace :apis do
  desc 'Sync countries from Contabilium, matching by name'

  task contab_countries: :environment do
    ActiveRecord::Base.transaction do
      Contab::Country.all.each do |c|
        mc = Country.find_by(name: c.Nombre)

        if mc
          puts "Found #{c.Nombre}, adding contabilium id."
          mc.contabilium_id = c.ID
          mc.save!
        else
          puts "Not found #{c.Nombre}"
        end
      end
    end
  end
end
