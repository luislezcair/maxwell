# frozen_string_literal: true

namespace :apis do
  desc 'Add organization Id from UCRM to existing clients matching by number '\
       '(userIdent)'

  task ucrm_organization: :environment do
    ActiveRecord::Base.transaction do
      total = 0
      UCRM::Client.all.each do |uc|
        user_ident = uc.userIdent.to_i

        if user_ident.zero?
          puts "Skipping user with invalid userIdent. ID #{uc.id}"
          next
        end

        mc = Client.find_by(number: user_ident)

        if mc
          org_id = Organization.find_by(ucrm_id: uc.organizationId.to_i).id
          mc.organization_id = org_id
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
