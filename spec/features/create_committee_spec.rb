require 'rails_helper'

RSpec.describe 'Creating a Committee', type: :feature do
  scenario 'valid inputs' do
    visit new_committees_path
    fill_in 'Name', with: 'Committee 1'
    click_on 'Create New Committee'
    visit committees_path
    expect(committee_name).to have_content('Committe 1')
  end

#Rainy day scenario
  scenario 'invalid inputs' do
    visit new_committees_path
    fill_in 'Name', with: ''
    click_on 'Create New Committee'
    expect(committee_name).to have_content("Title can't be blank")
  end
end
