# frozen_string_literal: true

require 'rails_helper'

describe CorporateCellphone do
  it 'has a valid factory' do
    b = build(:corporate_cellphone)
    expect(b).to be_valid
  end

  it 'is invalid without a phone number' do
    b = build(:corporate_cellphone, phone: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique phone number' do
    create(:corporate_cellphone)
    b2 = build(:corporate_cellphone)
    expect(b2).to_not be_valid
  end
end
