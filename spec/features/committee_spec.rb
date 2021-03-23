require 'rails_helper'

RSpec.describe 'Hello world', type: :feature do
   describe 'index page' do
       it 'shows the right content' do
           visit committee_path
           #sleep(10)
           expect(page).to have_content('Rhonda Hollier')
       end
   end
 end
