# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

context 'UCRM sends a notification event' do
  before do
    create(:country_arg)
    create(:province_misiones)
    create(:organization)

    Sidekiq::Testing.fake!
  end

  example 'client add hook' do
    webhook = create(:webhook_client_add)

    expect(Client.find_by(ucrm_id: webhook.entity_id)).to be_nil

    VCR.use_cassette('ucrm_client_add') do
      expect do
        UCRM::ClientAddJob.new.perform(webhook.id)
        webhook.reload
      end.to(change(webhook, :status).from('pending').to('completed'))
    end

    new_client = Client.find_by(ucrm_id: webhook.entity_id)
    expect(new_client).to_not be_nil

    expect(Contab::ClientCreateJob).to have_enqueued_sidekiq_job(new_client.id)
  end

  example 'client add hook fails with error' do
    webhook = create(:webhook_client_add_error)

    expect(Client.find_by(ucrm_id: webhook.entity_id)).to be_nil

    VCR.use_cassette('ucrm_client_add_fails') do
      expect do
        UCRM::ClientAddJob.new.perform(webhook.id)
        webhook.reload
      end.to(change(webhook, :status).from('pending').to('error'))
    end

    expect(Client.find_by(ucrm_id: webhook.entity_id)).to be_nil
    expect(webhook.error_msg).to_not be_blank

    expect(Contab::ClientCreateJob).to_not have_enqueued_sidekiq_job
  end
end
