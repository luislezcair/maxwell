# frozen_string_literal: true

namespace :apis do
  desc 'Add UCRM Id to existing clients matching by number (userIdent)'

  task ucrm_clients: :environment do
    ActiveRecord::Base.transaction do
      total = 0
      UCRM::Client.all.each do |uc|
        user_ident = uc.userIdent.to_i

        if uc.userIdent.to_i.zero?
          puts "Skipping user with invalid userIdent. ID #{uc.id}"
          next
        end

        mc = Client.find_by(number: user_ident)

        if mc
          mc.ucrm_id = uc.id
          mc.save!
          total += 1
        else
          puts "Client with userIdent #{user_ident} not found"
        end
      end

      puts "Updated #{total} clients."
    end
  end
end
