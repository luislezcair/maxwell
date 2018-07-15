# frozen_string_literal: true

require 'rails_helper'

describe City do
  it 'has a valid factory' do
    b = build(:city)
    expect(b).to be_valid
  end

  it 'is invalid without a name' do
    b = build(:city, name: nil)
    expect(b).to_not be_valid
  end
end
