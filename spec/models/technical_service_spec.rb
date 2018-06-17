# frozen_string_literal: true

require 'rails_helper'

describe TechnicalService do
  it 'has a valid factory' do
    b = build(:technical_service)
    expect(b).to be_valid
  end

  it 'is invalid without a work order number' do
    b = build(:technical_service, work_order_number: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid with a work order number greater than or equal to 2^30' do
    b = build(:technical_service, work_order_number: 2**30 + 1)
    expect(b).to_not be_valid
  end

  it 'is invalid with a plug adapter quantity greater than or equal to 2^30' do
    b = build(:technical_service, plug_adapter_quantity: 2**30 + 1)
    expect(b).to_not be_valid
  end

  it 'is invalid without an arrival time' do
    b = build(:technical_service, arrival_time: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a departure time' do
    b = build(:technical_service, departure_time: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a datetime' do
    b = build(:technical_service, datetime: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a city' do
    b = build(:technical_service, city: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a client' do
    b = build(:technical_service, client: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a ground wire setup type' do
    b = build(:technical_service, ground_wire_setup_type: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without a surge protector setup type' do
    b = build(:technical_service, surge_protector_setup_type: nil)
    expect(b).to_not be_valid
  end

  it 'is invalid without at least one work type' do
    ts = build(:technical_service, work_types_count: 0)
    expect(ts).to_not be_valid
  end

  it 'is invalid without at least one corporate cellphone' do
    ts = build(:technical_service, cellphones_count: 0)
    expect(ts).to_not be_valid
  end

  it 'is invalid without at least one technician' do
    ts = build(:technical_service, technicians_count: 0)
    expect(ts).to_not be_valid
  end
end
