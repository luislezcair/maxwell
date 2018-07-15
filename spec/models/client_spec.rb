# frozen_string_literal: true

require 'rails_helper'

describe Client do
  it 'has a valid factory' do
    b = build(:client)
    expect(b).to be_valid
  end

  # TODO: validate that firstname and lastname are present when it is a physical
  # person, and that company name is present when it is a company.

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
