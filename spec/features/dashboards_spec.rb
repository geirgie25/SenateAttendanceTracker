# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :feature do
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }

  describe 'Admin Dashboard:' do
    let(:r) { Role.create(role_name: 'Administrator') }
    let(:c) { Committee.create(committee_name: 'name') }
    let(:m) { Meeting.create(title: 'TestMeeting', start_time: Time.zone.now, end_time: Time.zone.now) }

    before do
      m.committee = c
      m.save
      u.roles << r
      u.save
      visit '/login'
      fill_in 'username', with: u.username
      fill_in 'password', with: u.password
      click_on 'login_button'
    end

    it 'wipe meeting data' do
      click_on 'Reset Attendance Tracking'
      expect(Meeting.all.first).to eq nil
    end

    it 'download records' do
      u.committees << c
      u.save
      AttendanceRecord.make_records_for(m)
      click_on 'Download Attendance Data'
      expect(page).to have_text('TestMeeting')
    end
  end
end
