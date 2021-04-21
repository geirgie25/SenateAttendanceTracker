require 'rails_helper'

RSpec.feature "LoginSpecs", type: :feature do
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:r) { Role.create(role_name: 'Administrator') }

  it "Login as user" do
    visit '/login'
    fill_in 'username', with: u.username
    fill_in 'password', with: u.password
    click_on 'login_button'
    expect(page).to have_content("Committee Attendance Summary")
  end

  it "Login as admin" do
    u.roles << r
    u.save
    visit '/login'
    fill_in 'username', with: u.username
    fill_in 'password', with: u.password
    click_on 'login_button'
    expect(page).to have_content("administrator")
  end

  it "logout" do
    visit '/login'
    fill_in 'username', with: u.username
    fill_in 'password', with: u.password
    click_on 'login_button'
    click_on 'Log Out'
    visit '/dashboards/user'
    expect(page).to have_content("Login");
  end

end
