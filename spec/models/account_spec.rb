# frozen_string_literal: true

require 'rails_helper'

describe Account do
  it 'has a valid factory' do
    a = build(:account)
    expect(a).to be_valid
  end

  it 'is invalid without a name' do
    a = build(:account, name: '')
    expect(a).to_not be_valid
  end

  it 'is invalid without a code' do
    a = build(:account, code: '')
    expect(a).to_not be_valid
  end

  it 'has a unique code' do
    create(:account, code: '1.1')
    a2 = build(:account, code: '1.1')

    expect(a2).to_not be_valid
  end

  it 'imputable account can not have children' do
    a = create(:account, imputable: true, code: '6.6.6')
    b = build(:account, parent: a)
    expect(b).to_not be_valid
  end

  it 'cannot change imputable attribute if it has children' do
    a = create(:account, code: '6.7.6')
    b = create(:account, code: '6.7.5', parent: a)
    expect(b).to be_valid

    b.imputable = true
    expect(b).to be_valid
    expect(b.save).to eq(true)

    a.imputable = true
    expect(a).to_not be_valid
    expect(a.save).to eq(false)
  end
end
