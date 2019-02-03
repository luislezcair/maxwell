# frozen_string_literal: true

require 'rails_helper'

context 'UCRM sends a notification event' do
  before do
    create(:province_misiones)
    create(:organization)
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

    expect(Client.find_by(ucrm_id: webhook.entity_id)).to_not be_nil
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
  end
end
