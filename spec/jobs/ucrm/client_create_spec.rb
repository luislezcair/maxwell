# frozen_string_literal: true

require 'rails_helper'

context 'A client is created and synchronized with UCRM' do
  example 'Maxwell creates a client in UCRM' do
    client = create(:client_edit_ucrm_old, ucrm_id: nil, number: 36_025)

    VCR.use_cassette('ucrm_client_create') do
      result = nil

      expect do
        result = UCRM::ClientCreateJob.new.perform(client.id)
        client.reload
      end.to(change(client, :ucrm_id).from(nil))

      expect(result.metadata[:status]).to eq(201)

      # Revertir la creación para ejecutar las pruebas nuevamente
      result.destroy
    end
  end

  example 'Client creation returns an error' do
    client = create(:client_edit_ucrm_new, ucrm_id: nil)

    VCR.use_cassette('ucrm_client_create_fails') do
      result = nil

      expect do
        result = UCRM::ClientCreateJob.new.perform(client.id)
        client.reload
      end.to_not(change(client, :ucrm_id))

      expect(result.metadata[:status]).to eq(422)
      expect(result.errors).to have_key(:userIdent)
    end
  end
end
