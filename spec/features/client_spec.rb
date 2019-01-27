# frozen_string_literal: true

require 'rails_helper'

feature 'Client management' do
  before do
    login_as(create(:user))

    @client = build(:client)
    @company_client = build(:company_client, organization: @client.organization)

    create(:country, name: 'Argentina')
    create(:province, name: 'Misiones')
  end

  scenario 'User selects client type person / company' do
    visit new_client_path
    expect(page).to have_content t_string_c('new.form.new_header')

    form = find('form')

    select(t_enum('client_type.company'), from: 'client_client_type')
    expect(form).to have_selector('#client_company_name', visible: true)
    expect(form).to_not have_selector('#client_firstname')
    expect(form).to_not have_selector('#client_lastname')

    select(t_enum('client_type.person'), from: 'client_client_type')
    expect(form).to have_selector('#client_firstname', visible: true)
    expect(form).to have_selector('#client_lastname', visible: true)
    expect(form).to_not have_selector('#client_company_name')
  end

  scenario 'User creates a new person client' do
    visit new_client_path

    fill_in_form_for(@client)
    check_expectations_for(@client)
  end

  scenario 'User creates a new company client' do
    visit new_client_path

    fill_in_form_for(@company_client)
    check_expectations_for(@company_client)
  end
end

feature 'Client management from another organization' do
  before do
    @user = create(:foreign_user)
    login_as(@user)

    @client = create(:foreign_client, organization: @user.group.organization)
    @client_other = create(:client)

    create(:country, name: 'Argentina')
    create(:province, name: 'Misiones')
  end

  scenario 'User sees only clients from his/her organization' do
    visit clients_path

    expect(page).to have_select('q_organization_id_eq',
                                options: [I18n.t('search_form.any'),
                                          @user.group.organization.name])

    org_header = find('.card-header > .title')
    expect(org_header).to have_content t_string_c('index.header').upcase
    expect(org_header).to have_content @user.group.organization.name.upcase

    table = find('.card-body table')
    expect(table).to have_content @client.name
    expect(table).to have_content @client.organization.name

    expect(table).to_not have_content @client_other.name
    expect(table).to_not have_content @client_other.organization.name
  end

  scenario 'User can add clients only to his/her organization' do
    visit new_client_path

    expect(page).to have_select('client_organization_id',
                                options: [@user.group.organization.name])
  end

  scenario 'User can not view UCRM/Contabilium links in client details' do
    visit client_path(@client)

    expect(page).to_not have_link(nil, href: ucrm_client_link(@client.ucrm_id))

    expect(page).to_not have_link(
      nil,
      href: contabilium_client_link(@client.contabilium_id)
    )
  end
end

# Rellena los campos del formulario con los datos del cliente pasado como
# parámetro, con los datos correspondientes si el cliente es una persona o
# empresa.
#
def fill_in_form_for(client)
  within 'form' do
    if client.company?
      select t_enum('client_type.company'), from: 'client_client_type'
      expect(page).to have_selector('#client_company_name', visible: true)

      fill_in('client_company_name', with: client.company_name)
    else
      fill_in('client_firstname', with: client.firstname)
      fill_in('client_lastname', with: client.lastname)
    end

    fill_in('client_address', with: client.address)

    select client.organization.name, from: 'client_organization_id'
    select client.document_type_text, from: 'client_document_type'

    fill_in('client_document_number', with: client.document_number)
    fill_in('client_number', with: client.number)

    click_button(t_string_c('form.submit'))
  end
end

# Comprueba que los datos del cliente recién cargado se muestren en la vista de
# detalles del cliente.
#
def check_expectations_for(client)
  expect(page).to have_content(t_string_c('show.header').upcase)

  last_client_path = client_path(Client.last)
  expect(page).to have_current_path(last_client_path)

  within '.card-body' do
    expect(page).to have_content(client.name)
    expect(page).to have_content(client.address)
    expect(page).to have_content(client.organization.name)
    expect(page).to have_content(client.document_type_text)
    expect(page).to have_content(cuit_dni(client))
    expect(page).to have_content(client.number)
  end
end

def t_string_c(scope)
  I18n.t("clients.#{scope}")
end

def t_enum(value)
  I18n.t("enumerize.client.#{value}")
end
