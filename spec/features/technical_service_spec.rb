# frozen_string_literal: true

require 'rails_helper'

feature 'User login' do
  scenario 'New Technical Service' do
    login_as(create(:user))

    visit new_technical_service_path
    expect(page).to have_content t_string('new.form.new_header')
  end
end

def t_string(scope)
  I18n.t("technical_services.#{scope}")
end
