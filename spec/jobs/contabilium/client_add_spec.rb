# frozen_string_literal: true

require 'rails_helper'

context 'Create a client in Contabilium' do
  example 'successful creation' do
    client = create(:contabilium_client_create)

    VCR.use_cassette('contabilium_client_add') do
      expect(find_contabilium_client(client.document_number)).to be_nil

      expect do
        Contab::ClientCreateJob.new.perform(client.id)
        client.reload
      end.to(change(client, :contabilium_id).from(nil))

      contab_client = Contab::Client.find(client.contabilium_id)
      expect(contab_client).to_not be_nil

      # Para poder volver a ejecutar las pruebas
      contab_client.destroy
    end
  end

  example 'failure on creation because of invalid CUIT' do
    client = create(:contabilium_client_create_fail)

    VCR.use_cassette('contabilium_client_add_fails') do
      expect(find_contabilium_client(client.document_number)).to be_nil

      expect do
        Contab::ClientCreateJob.new.perform(client.id)
        client.reload
      end.to_not(change(client, :contabilium_id).from(nil))

      expect(find_contabilium_client(client.document_number)).to be_nil
    end
  end
end

# Utilizar Contab::Client.collection.find(1, cuit) para buscar porque no tenemos
# id al principio y al llamar a save! no se establece el id tampoco
def find_contabilium_client(cuit)
  Contab::Client.collection(1, cuit).first
end
