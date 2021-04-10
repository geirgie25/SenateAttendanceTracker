# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Creating a Committee', type: :feature do
  let(:r2) { Role.create(role_name: 'Administrator') }
  let(:u) { User.create(username: 'admin', name: 'Administrator', password: 'password') }

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

  it 'valid inputs for unexcused absences' do
    a = Committee.create!(max_unexcused_absences: '6', committee_name: 'Committe 1')
    visit edit_committee_path(id: a.id)
    fill_in 'committee_max_unexcused_absences', with: '7'
    click_on 'Update Committee'
    expect(Committee.find_by(max_unexcused_absences: '6')).to be_truthy
  end

  # Rainy day scenario
  it 'invalid inputs for unexcused absences' do
    a = Committee.create!(max_unexcused_absences: '6', committee_name: 'Committe 1')
    visit edit_committee_path(id: a.id)
    fill_in 'committee_max_unexcused_absences', with: ''
    click_on 'Update Committee'
    expect(Committee.find_by(max_unexcused_absences: '')).to eq nil
  end

  it 'valid inputs for exused absences' do
    b = Committee.create!(max_excused_absences: '11', committee_name: 'Committe 1')
    visit edit_committee_path(id: b.id)
    fill_in 'committee_max_excused_absences', with: '12'
    click_on 'Update Committee'
    expect(Committee.find_by(max_excused_absences: '12')).to be_truthy
  end

  # Rainy day scenario
  it 'invalid inputs for exused absences' do
    b = Committee.create!(max_excused_absences: '11', committee_name: 'Committe 1')
    visit edit_committee_path(id: b.id)
    fill_in 'committee_max_excused_absences', with: ''
    click_on 'Update Committee'
    expect(Committee.find_by(max_excused_absences: '')).to eq nil
  end

  it 'valid inputs for combined absences' do
    c = Committee.create!(max_combined_absences: '11', committee_name: 'Committe 1')
    visit edit_committee_path(id: c.id)
    fill_in 'committee_max_combined_absences', with: '12'
    click_on 'Update Committee'
    expect(Committee.find_by(max_combined_absences: '12')).to be_truthy
  end

  # Rainy day scenario
  it 'invalid inputs for combined absences' do
    c = Committee.create!(max_combined_absences: '11', committee_name: 'Committe 1')
    visit edit_committee_path(id: c.id)
    fill_in 'committee_max_combined_absences', with: ''
    click_on 'Update Committee'
    expect(Committee.find_by(max_combined_absences: '')).to eq nil
  end
end
