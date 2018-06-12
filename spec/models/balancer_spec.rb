# frozen_string_literal: true

require 'rails_helper'

describe Balancer do
  it 'has a valid factory' do
    b = build(:balancer)
    expect(b).to be_valid
  end

  it 'is invalid without a name' do
    b = build(:balancer, name: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique case-insensitive name' do
    b = create(:balancer)
    b2 = build(:balancer, name: b.name.upcase)
    expect(b2).to_not be_valid
  end
end
