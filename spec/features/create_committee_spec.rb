# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a Committee', type: :feature do
  let(:r2) { Role.create(role_name: 'Administrator') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }

  before do
    u.roles << r2
    u.save
    visit '/login'
    fill_in 'username', with: u.username
    fill_in 'password', with: u.password
    click_on 'login_button'
  end

  it 'valid inputs' do
    visit new_committee_path
    fill_in 'committee_committee_name', with: 'Committee 1'
    click_on 'Create New Committee'
    expect(Committee.find_by(committee_name: 'Committee 1')).to be_truthy
  end

  # Rainy day scenario
  it 'invalid inputs' do
    visit new_committee_path
    fill_in 'committee_committee_name', with: ''
    click_on 'Create New Committee'
    expect(Committee.find_by(committee_name: '')).to eq nil
  end
end
