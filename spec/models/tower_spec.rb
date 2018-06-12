# frozen_string_literal: true

require 'rails_helper'

describe Tower do
  it 'has a valid factory' do
    b = build(:tower)
    expect(b).to be_valid
  end

  it 'is invalid without a name' do
    b = build(:tower, name: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a UCRM site ID' do
    b = build(:tower, ucrm_site_id: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a unique name' do
    b = create(:tower)
    b2 = build(:tower, ucrm_site_id: 1, name: b.name.upcase)
    expect(b2).to_not be_valid
  end
end
