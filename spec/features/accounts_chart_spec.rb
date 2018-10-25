# frozen_string_literal: true

require 'rails_helper'

def t_string_a(scope)
  I18n.t("accounts.#{scope}")
end

feature 'Accounts Chart' do
  before do
    login_as(create(:user))

    @account_a = create(:account)
    create(:account, code: '1.1', name: 'Caja y Banco', parent: @account_a)
    create(:account, code: '1.2', name: 'Deudores', parent: @account_a)

    @account_b = create(:account, name: 'Pasivo', code: '2')
    create(:account, name: 'Pasivo child 1', code: '2.1', parent: @account_b)
    create(:account, name: 'Pasivo child 2', code: '2.2', parent: @account_b)
  end

  scenario 'User visits the index page' do
    visit accounts_path
    expect(page).to have_content t_string_a('index.header').upcase

    expect(find('div[data-controller]')['data-accounts-chart-url']).to(
      eq(accounts_path(format: :json))
    )

    chart = find('#accounts-table-container')
    expect(chart).to have_css('.jstree')

    within chart do
      click_and_check_account(chart, @account_a)
      click_and_check_account(chart, @account_b)
    end
  end
end

# Busca la cuenta en el contenedor chart y verifica que contenga el nombre de
# la cuenta, hace click en el ícono <i> para expandir el nodo y verifica que
# las cuentas descendientes también tengan el nombre de cuenta.
#
def click_and_check_account(chart, account)
  root_node = chart.find("#acc_#{account.id}_anchor")
  expect(root_node).to have_text(account.name)

  root_node.sibling('i.jstree-icon').click
  root_children = root_node.sibling('ul.jstree-children')

  within root_children do
    account.children.find_each do |child|
      child_anchor = root_children.find("#acc_#{child.id}_anchor")
      expect(child_anchor).to have_text(child.name)
    end
  end
end
