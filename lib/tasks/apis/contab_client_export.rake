# frozen_string_literal: true

namespace :apis do
  desc 'Export clients from Maxwell to Contabilium'

  task export_clients: :environment do
    ActiveRecord::Base.transaction do
      total = 0
      clients = Client.where.not(ucrm_id: nil, contabilium_id: nil)

      clients.find_each do |mc|
        cc = Contab::Client.from_model(mc)

        if cc.save
          mc.contabilium_id = cc.response_id
          mc.save!
          total += 1
        else
          puts "Client ID #{mc.id} could not be saved in Contabilium."
        end
      end

      puts "Updated #{total}/#{clients.size} clients."
    end
  end
end
