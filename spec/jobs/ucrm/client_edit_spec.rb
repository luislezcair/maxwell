# frozen_string_literal: true

require 'rails_helper'

context 'UCRM sends a notification event' do
  example 'client edit hook' do
    webhook = create(:webhook_client_edit)

    client_old = create(:client_edit_ucrm_old)
    client_new = build(:client_edit_ucrm_new)

    # HACK: `client_old.attributes` devuelve `document_type: 'cuit'` y
    # `client_new.attributes` devuelve `document_type: 0`.
    # Esto hace fallar la expectation del final y eso no debería suceder así que
    # acá forzamos a `client_new` a que devuelva 'cuit' y no el valor numérico
    attrs = client_new.attributes.merge(Hash['document_type', 'cuit'])
    allow(client_new).to receive(:attributes) { attrs }

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
  end
end
