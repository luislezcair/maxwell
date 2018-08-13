# frozen_string_literal: true

namespace :crontab do
  desc 'Launch ClientSyncJob to sync clients with Contabilium and UCRM'

  task client_sync: :environment do
    ClientSyncJob.perform_async
  end
end
