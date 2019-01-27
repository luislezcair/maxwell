# frozen_string_literal: true

require 'rails_helper'

describe Client do
  it 'has a valid factory' do
    b = build(:client)
    expect(b).to be_valid
  end

  it 'needs a first and lastname when it is a person' do
    b = build(:client, client_type: :person, firstname: '')
    expect(b).to_not be_valid

    b = build(:client, client_type: :person, lastname: '')
    expect(b).to_not be_valid
  end

  it 'needs a company_name when it is a company' do
    b = build(:client, client_type: :company, company_name: '')
    expect(b).to_not be_valid

    b = build(:client, client_type: :company, company_name: 'Ksys')
    expect(b).to be_valid
  end

  it 'needs a CUIT when it is a company' do
    b = build(:company_client)
    expect(b).to be_valid

    b = build(:company_client, document_type: :dni)
    expect(b).to_not be_valid
  end

  it 'is invalid without a number' do
    b = build(:client, number: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique number' do
    b1 = create(:client)
    b2 = build(:client, number: b1.number)
    expect(b2).to_not be_valid
  end

  it 'is invalid without a document_number' do
    b = build(:client, document_number: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique document_number' do
    b = create(:client)
    b2 = build(:client, document_number: b.document_number)
    expect(b2).to_not be_valid
  end

  it 'is invalid without a valid email' do
    b = build(:client, email: 'luislezcair@gmail.com')
    expect(b).to be_valid

    b.email = 'luislezcair@gmail,com'
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique ucrm_id' do
    b = create(:client)
    b2 = build(:client, ucrm_id: b.ucrm_id)
    expect(b2).to_not be_valid
  end

  it 'is invalid without a unique contabilium_id' do
    b = create(:client)
    b2 = build(:client, contabilium_id: b.contabilium_id)
    expect(b2).to_not be_valid
  end

  it 'is valid when ucrm_id or contabilium_id are null' do
    ucrm = create(:client, ucrm_id: nil)
    ucrm2 = create(:client, ucrm_id: nil)
    expect(ucrm).to be_valid
    expect(ucrm2).to be_valid

    contab = create(:client, contabilium_id: nil)
    contab2 = create(:client, contabilium_id: nil)
    expect(contab).to be_valid
    expect(contab2).to be_valid
  end
end
