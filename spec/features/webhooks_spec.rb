# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'
require 'support/fake_ucrm_webhook'

feature 'UCRM integration' do
  before do
    Sidekiq::Testing.fake!
  end

  scenario 'receives a notification from UCRM and saves the webhook' do
    @webhooker = fake_ucrm_webhook(build(:webhook_test))
    uuid = @webhooker.body[:uuid]

    expect(find_webhook(uuid)).to be_nil
    expect { @webhooker.send }.to_not change(Sidekiq::Queues['default'], :size)
    expect(find_webhook(uuid)).to_not be_nil
  end

  scenario 'receives a client.add notification from UCRM' do
    @webhooker = fake_ucrm_webhook(build(:webhook_client_add))
    expect { @webhooker.send }.to change(UCRM::ClientAddJob.jobs, :size).by(1)
  end

  scenario 'receives a client.edit event from UCRM' do
    @webhooker = fake_ucrm_webhook(build(:webhook_client_edit))
    expect { @webhooker.send }.to change(UCRM::ClientEditJob.jobs, :size).by(1)
  end
end

def find_webhook(uuid)
  UcrmWebhook.find_by(uuid: uuid)
end

def fake_ucrm_webhook(webhook)
  FakeUcrmWebhook.new(
    host: Capybara.current_session.server.host,
    port: Capybara.current_session.server.port,
    path: 'system/ucrm_webhooks',
    webhook: webhook
  )
end
