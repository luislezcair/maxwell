# frozen_string_literal: true

require 'rails_helper'

describe Device do
  it 'has a valid factory' do
    b = build(:device)
    expect(b).to be_valid
  end

  it 'is invalid without a model name' do
    b = build(:device, model: nil)
    expect(b).to_not be_valid
  end
end
