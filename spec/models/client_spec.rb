# frozen_string_literal: true

require 'rails_helper'

describe Client do
  it 'has a valid factory' do
    b = build(:client)
    expect(b).to be_valid
  end

  it 'is invalid without a first name' do
    b = build(:client, firstname: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a last name' do
    b = build(:client, lastname: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a number' do
    b = build(:client, number: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique number' do
    create(:client)
    b2 = build(:client)
    expect(b2).to_not be_valid
  end
end
