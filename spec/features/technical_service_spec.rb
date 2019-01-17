# frozen_string_literal: true

require 'rails_helper'

feature 'Technical services' do
  before do
    login_as(create(:user))

    @ts = build(:technical_service)

    @techs = create_list(:technician_with_sequence, 2)
    @wss = create_list(:work_type_with_sequence, 2)
    @ccs = create_list(:cellphone_with_sequence, 2)
    @client = Client.first
  end

  scenario 'User creates a new Technical Service' do
    visit new_technical_service_path
    expect(page).to have_content t_string('new.form.new_header')

    fill_in('technical_service_client', with: 'steph')

    # Click en la primera sugerencia de la lista de clientes
    find('.ui-autocomplete > .ui-menu-item:first-child').click

    within('form') do
      fill_in('technical_service_work_order_number',
              with: @ts.work_order_number)
      select @ts.city.name, from: 'technical_service_city_id'
      check(@techs.first.to_label)

      el = find('#technical_service_arrival_time').click
      el.send_keys @ts.arrival_time.strftime('%H:%m').split

      el = find('#technical_service_departure_time').click
      el.send_keys @ts.departure_time.strftime('%H:%m').split

      check(@wss.first.name)
      check(@wss.last.name)
      check(@ccs.first.to_label)
    end

    client_input = find('#technical_service_client')
    expect(client_input.value).to eq(ClientsHelper.client_label(@client))

    click_button(t_string('form.submit'))
    expect(page).to have_content(t_string('show.section.client').upcase)

    last_ts_path = technical_service_path(TechnicalService.last)
    expect(page).to have_current_path(last_ts_path)
  end
end

def t_string(scope)
  I18n.t("technical_services.#{scope}")
end
