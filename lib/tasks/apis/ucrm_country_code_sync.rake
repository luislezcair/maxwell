# frozen_string_literal: true

namespace :apis do
  desc 'Sync country codes from UCRM, matching by ucrm_id'

  task ucrm_country_codes: :environment do
    ActiveRecord::Base.transaction do
      UCRM::Country.all.each do |c|
        uc = Country.find_by(ucrm_id: c.id)

        if uc
          puts "Found #{c.name}, adding UCRM ISO code."
          uc.code = c.code
          uc.save!
        else
          puts "Not found #{c.name}"
        end
      end
    end
  end
end
