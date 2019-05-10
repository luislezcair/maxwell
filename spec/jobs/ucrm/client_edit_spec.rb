# frozen_string_literal: true

require 'rails_helper'

context 'UCRM sends a notification event' do
  example 'client edit hook' do
    webhook = create(:webhook_client_edit)

    client_old = create(:client_edit_ucrm_old)
    client_new = build(:client_edit_ucrm_new,
                       organization: create(:organization),
                       country: create(:country_arg))

    VCR.use_cassette('ucrm_client_edit') do
      expect do
        UCRM::ClientEditJob.new.perform(webhook.id)
        webhook.reload
        client_old.reload
      end.to(change(webhook, :status).from('pending').to('completed'))
    end

    old_attrs = client_old.attributes_for_ucrm_update
    new_attrs = client_new.attributes_for_ucrm_update

    expect(old_attrs).to eq(new_attrs)

    expect(Contab::ClientEditJob).to have_enqueued_sidekiq_job(client_old.id)
  end

  example 'client edit hook fails with error' do
    webhook = create(:webhook_client_edit_error)

    # Este cliente no tiene definido CUIT / DNI en UCRM así que falla la
    # validación al actualizar los atributos
    client_old = create(:client_edit_ucrm_error)
    old_attrs = client_old.attributes_for_ucrm_update

    VCR.use_cassette('ucrm_client_edit_fails') do
      expect do
        UCRM::ClientEditJob.new.perform(webhook.id)
        webhook.reload
        client_old.reload
      end.to(change(webhook, :status).from('pending').to('error'))
    end

    new_attrs = client_old.attributes_for_ucrm_update
    expect(old_attrs).to eq(new_attrs)

    expect(webhook.error_msg).to_not be_blank

    expect(Contab::ClientEditJob).to_not have_enqueued_sidekiq_job
  end

  example 'the edited client does not exist in maxwell' do
    webhook = create(:webhook_client_edit_not_existant)

    expect(Client.find_by(ucrm_id: webhook.entity_id)).to be_nil

    VCR.use_cassette('ucrm_client_edit_not_existant') do
      expect do
        UCRM::ClientEditJob.new.perform(webhook.id)
        webhook.reload
      end.to(change(webhook, :status).from('pending').to('error'))
    end

    expect(webhook.error_msg).to_not be_blank
    expect(Client.find_by(ucrm_id: webhook.entity_id)).to be_nil

    expect(Contab::ClientEditJob).to_not have_enqueued_sidekiq_job
  end
end
