# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LoginSpecs', type: :feature do
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:r) { Role.create(role_name: 'Administrator') }

  it 'Login as user' do
    login(u.username, u.password)
    expect(page).to have_content('Committee Attendance Summary')
  end

  it 'Login as admin' do
    u.roles << r
    u.save
    login(u.username, u.password)
    expect(page).to have_content('administrator')
  end

  it 'logout' do
    login(u.username, u.password)
    click_on 'Log Out'
    visit '/dashboards/user'
    expect(page).to have_content('Login')
  end

  def login(username, password)
    visit '/login'
    fill_in 'username', with: username
    fill_in 'password', with: password
    click_on 'login_button'
  end
end
