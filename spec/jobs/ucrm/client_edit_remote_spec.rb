# frozen_string_literal: true

require 'rails_helper'

context 'A client is updated and synchronized with UCRM' do
  example 'Maxwell updates a client in UCRM' do
    client_new = create(:client_edit_ucrm_old)

    VCR.use_cassette('ucrm_client_edit_remote') do
      result = UCRM::ClientEditRemoteJob.new.perform(client_new.id)

      expect(result).to be_instance_of UCRM::Client

      expect(result.metadata[:status]).to eq(200)
      expect(result.has_errors?).to be false

      # Revertir la creación para ejecutar las pruebas nuevamente
      client_new.destroy
      client_old = create(:client_edit_ucrm_new)

      result = UCRM::ClientEditRemoteJob.new.perform(client_old.id)

      expect(result.metadata[:status]).to eq(200)
      expect(result.has_errors?).to be false
    end
  end

  example 'Client update returns an error, client number is in use' do
    client = create(:client_edit_ucrm_old, number: 888)

    VCR.use_cassette('ucrm_client_edit_remote_fails') do
      result = UCRM::ClientEditRemoteJob.new.perform(client.id)
      expect(result).to be_instance_of UCRM::Client

      expect(result.metadata[:status]).to eq(422)
      expect(result.errors).to have_key(:userIdent)
    end
  end
end
