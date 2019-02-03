# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

describe UcrmWebhook do
  before do
    Sidekiq::Testing.fake!
  end

  it 'has a valid factory' do
    w = build(:webhook_test)
    expect(w).to be_valid
  end

  it 'has an enumerized status attribute' do
    w = build(:webhook_test)

    expect(w).to(
      enumerize(:status).in(:pending, :processing, :completed, :error)
                        .with_default(:pending)
                        .with_predicates(true)
    )
  end

  it 'has a processing! method to set status to processing' do
    w = build(:webhook_test)
    expect { w.processing! }.to(
      change(w, :status).from('pending').to('processing')
    )
  end

  it 'has a completed! method to set status to completed' do
    w = build(:webhook_test)
    expect { w.completed! }.to(
      change(w, :status).from('pending').to('completed')
    )
  end

  it 'has an error! method to set status to error' do
    w = build(:webhook_test)
    error = 'this is an error message'

    expect { w.error!(error) }.to(
      change(w, :status).from('pending').to('error').and(
        change(w, :error_msg).from(nil).to(error)
      )
    )
  end

  it 'does not launch a job if it is not persisted' do
    w = build(:webhook_test)
    expect(w.launch_action).to be false
  end

  it 'does not launch a job when the event type is unknown' do
    w = create(:webhook_test, event_name: 'unexistant.do')
    expect(w.launch_action).to be false
  end

  it 'enqueues a job when it is persisted and the event is valid' do
    w = create(:webhook_client_add)

    expect { w.launch_action }.to(
      change(Sidekiq::Queues['default'], :size).by(1)
    )
  end
end
