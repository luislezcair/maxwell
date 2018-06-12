# frozen_string_literal: true

require 'rails_helper'

describe PlanService do
  it 'has a valid factory' do
    b = build(:plan_service)
    expect(b).to be_valid
  end

  it 'is invalid without a name' do
    b = build(:plan_service, name: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique name' do
    b = create(:plan_service)
    b2 = build(:plan_service, name: b.name.upcase)
    expect(b2).to_not be_valid
  end
end
