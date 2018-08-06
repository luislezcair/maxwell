# frozen_string_literal: true

require 'rails_helper'

feature 'User login' do
  scenario 'Show login form' do
    visit '/'
    remember_me_key = 'activerecord.attributes.user.remember_me'
    expect(page).to have_content I18n.t(remember_me_key)
  end

  scenario 'Invalid user tries to login to the site' do
    user = build(:user)

    visit '/'

    within 'form' do
      fill_in 'user_login', with: user.email
      fill_in 'user_password', with: user.password
      click_button
    end

    expect(page).to have_content I18n.t('.devise.failure.user.invalid')
  end

  scenario 'Valid user logins to the site' do
    user = create(:user)

    visit '/'

    within 'form' do
      fill_in 'user_login', with: user.email
      fill_in 'user_password', with: user.password
      click_button
    end

    expect(page).to have_content 'Inicio'
  end
end
