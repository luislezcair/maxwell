# frozen_string_literal: true

require 'rails_helper'

feature 'Technical services' do
  before do
    login_as(create(:user))

    city = create(:city)
    @client = create(:client)
    @ts = build(:technical_service, client: @client, city: city)

    @techs = create_list(:technician_with_sequence, 2)
    @wss = create_list(:work_type_with_sequence, 2)
    @ccs = create_list(:cellphone_with_sequence, 2)
  end

  scenario 'User selects a client in the form' do
    my_client = create(:client_with_service)

    visit new_technical_service_path
    expect(page).to have_content t_string_ts('new.form.new_header')

    fill_in('technical_service_client', with: 'kane')

    # Click en la primera sugerencia de la lista de clientes
    find('.ui-autocomplete > .ui-menu-item:first-child').click

    client_input = find('#technical_service_client')
    expect(client_input.value).to eq(client_label(my_client))

    form = find('form')

    expect(form).to have_select(
      'technical_service_city_id',
      selected: my_client.city.name
    )

    expect(form).to have_select(
      'technical_service_plan_service_id',
      selected: my_client.plan_service.name
    )
  end

  scenario 'User creates a new Technical Service' do
    visit new_technical_service_path
    expect(page).to have_content t_string_ts('new.form.new_header')

    fill_in('technical_service_client', with: 'steph')

    # Click en la primera sugerencia de la lista de clientes
    find('.ui-autocomplete > .ui-menu-item:first-child').click

    client_input = find('#technical_service_client')
    expect(client_input.value).to eq(client_label(@client))

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

    click_button(t_string_ts('form.submit'))

    header = find('.card-header > .title')
    expect(header).to have_content(t_string_ts('show.header').upcase)

    last_ts_path = technical_service_path(TechnicalService.last)
    expect(page).to have_current_path(last_ts_path)

    # Comprobar los datos cargados en la interfaz show
    within('.card-body') do
      expect(page).to have_content(@ts.client.to_label)
      expect(page).to have_content(@ts.city.name)
      expect(page).to have_content(@ts.work_order_number)

      expect(page).to have_content(@techs.first.name)
      expect(page).to have_content(@wss.first.name)
      expect(page).to have_content(@wss.last.name)
      expect(page).to have_content(@ccs.first.to_label)

      expect(page).to have_content(@ts.arrival_time.strftime('%H:%m'))
      expect(page).to have_content(@ts.departure_time.strftime('%H:%m'))
    end
  end
end

feature 'Technical Services from another organization' do
  before do
    # Nos loqueamos con un usuario perteneciente a otra empresa
    @user = create(:foreign_user)
    login_as(@user)

    # Creamos un cliente perteneciente a otra empresa y un servicio técnico
    # para ese cliente también en nombre de esta otra empresa.
    @client = create(:foreign_client, organization: @user.group.organization)
    @ts = create(:foreign_technical_service,
                 organization: @user.group.organization,
                 client: @client)

    # Creamos un servicio técnico que no pertenece a esa empresa
    @ts_other = create(:technical_service)
  end

  scenario 'Foreign user sees only TS from his/her organization' do
    # El usuario logueado perteneciente a otra emepresa solamente debería ver
    # los servicios técnicos realizados para su empresa.
    visit technical_services_path

    org_header = find('.card-header > .title')
    expect(org_header).to have_content t_string_ts('index.header').upcase
    expect(org_header).to have_content @user.group.organization.name.upcase

    table = find('.card-body table')
    expect(table).to have_content @ts.client.name
    expect(table).to have_content @ts.work_order_number
    expect(table).to_not have_content @ts_other.client.name
  end
end

def t_string_ts(scope)
  I18n.t("technical_services.#{scope}")
end
