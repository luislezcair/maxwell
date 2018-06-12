# frozen_string_literal: true

require 'rails_helper'

describe Transmitter do
  it 'has a valid factory' do
    b = build(:transmitter)
    expect(b).to be_valid
  end

  it 'is invalid without a name' do
    b = build(:transmitter, name: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique name' do
    b = create(:transmitter)
    b2 = build(:transmitter, name: b.name.upcase)
    expect(b2).to_not be_valid
  end
end
