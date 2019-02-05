# frozen_string_literal: true

require 'rails_helper'

context 'Edit a client in Contabilium' do
  example 'successful modification' do
    local_client_old = build(:contabilium_client_edit_old)
    local_client_new = create(:contabilium_client_edit_new)

    VCR.use_cassette('contabilium_client_edit') do
      client_old = Contab::Client.find(local_client_old.contabilium_id)
      expect(client_old).to_not be_nil

      # El cliente en Contabilium debe tener los datos desactualizados
      old_attrs_remote = client_old.to_maxwell_model
                                   .attributes_for_contabilium_update
      old_attrs_local = local_client_old.attributes_for_contabilium_update
      expect(old_attrs_remote).to eq(old_attrs_local)

      # Lanzamos la actualización
      Contab::ClientEditJob.new.perform(local_client_new.id)

      # El cliente en Contabilium debe tener los datos actualizados
      client_new = Contab::Client.find(local_client_new.contabilium_id)
      expect(client_new).to_not be_nil

      new_attrs_remote = client_new.to_maxwell_model
                                   .attributes_for_contabilium_update
      new_attrs_local = local_client_new.attributes_for_contabilium_update
      expect(new_attrs_remote).to eq(new_attrs_local)

      # Revertimos los cambios en Contabilium para poder ejecutar nuevamente
      # las pruebas
      Contab::Client.from_model(local_client_old).save
    end
  end

  example 'fails because of invalid CUIT' do
    local_client_old = build(:contabilium_client_edit_old)
    local_client_new = create(:contabilium_client_edit_new,
                              document_number: 27_769_884_561)

    VCR.use_cassette('contabilium_client_edit_fails') do
      client_old = Contab::Client.find(local_client_old.contabilium_id)
      expect(client_old).to_not be_nil

      # El cliente en Contabilium debe tener los datos desactualizados
      old_attrs_remote = client_old.to_maxwell_model
                                   .attributes_for_contabilium_update
      old_attrs_local = local_client_old.attributes_for_contabilium_update
      expect(old_attrs_remote).to eq(old_attrs_local)

      # Lanzamos la actualización
      Contab::ClientEditJob.new.perform(local_client_new.id)

      # El cliente en Contabilium debe tener los datos desactualizados porque
      # el CUIT no es válido
      client_new = Contab::Client.find(local_client_new.contabilium_id)
      expect(client_new).to_not be_nil

      new_attrs_remote = client_new.to_maxwell_model
                                   .attributes_for_contabilium_update
      expect(new_attrs_remote).to eq(old_attrs_local)
    end
  end
end
