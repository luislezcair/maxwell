# frozen_string_literal: true

require 'rails_helper'

describe Technician do
  it 'has a valid factory' do
    b = build(:technician)
    expect(b).to be_valid
  end

  it 'is invalid without a firstname' do
    b = build(:technician, firstname: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a lastname' do
    b = build(:technician, lastname: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique name' do
    b = create(:technician)
    b2 = build(:technician,
               firstname: b.firstname.upcase,
               lastname: b.lastname.upcase)
    expect(b2).to_not be_valid
  end
end
