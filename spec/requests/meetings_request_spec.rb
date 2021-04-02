# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Meetings', type: :request do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:r) { Role.create(role_name: 'TestCommitteeHead') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi2', password: 'pass2') }

  before do
    c.roles << r
    u.roles << r
    c.save
    u.save
  end

  describe 'Index:' do
    it 'get meetings index page if not logged in' do
      get meetings_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Start Meeting:' do
    it "can't start if not logged in" do
      post meeting_new_path, params: { committee_id: c.id, meeting_title: 'test_meeting1' }
      expect(response).to redirect_to('/login')
    end

    it "can't start if don't have permission" do
      sign_user_in(u2)
      post meeting_new_path, params: { committee_id: c.id, meeting_title: 'test_meeting2' }
      expect(c.current_meeting?).to eq false
    end

    it 'starts if have permission' do
      sign_user_in(u)
      post meeting_new_path, params: { committee_id: c.id, meeting_title: 'test_meeting3' }
      expect(c.current_meeting?).to eq true
    end
  end

  describe 'End Meeting:' do
    let(:m) { Meeting.create(committee: c, title: 'test_meeting', start_time: Time.zone.now) }

    it "can't end if not logged in" do
      post end_meeting_path(m.id), params: { committee_id: c.id }
      expect(response).to redirect_to('/login')
    end

    it "can't end if don't have role" do
      sign_user_in(u2)
      post end_meeting_path(m.id), params: { committee_id: c.id }
      expect(c.current_meeting?).to eq true
    end

    it 'ends if have role' do
      sign_user_in(u)
      post end_meeting_path(m.id), params: { committee_id: c.id }
      expect(c.current_meeting?).to eq false
    end
  end

  describe 'Meeting Title:' do
    before do
      sign_user_in(u)
    end

    it 'meeting title set' do
      m_title = 'test_meeting'
      post meeting_new_path, params: { committee_id: c.id, meeting_title: m_title }
      expect(c.current_meeting.title).to eq m_title
    end

    it 'meeting title default' do
      post meeting_new_path, params: { committee_id: c.id, meeting_title: '' }
      expect(c.current_meeting.title).not_to eq ''
    end
  end

  describe 'Sign-In:' do
    before do
      u2.committees << c
      sign_user_in(u)
      post meeting_new_path, params: { committee_id: c.id }
    end

    it 'sign in if part of committee' do
      sign_user_in(u2)
      post sign_in_meeting_path(c.current_meeting.id)
      expect(AttendanceRecord.find_record(c.current_meeting, u2).attended).to eq true
    end

    it 'show meeting page' do
      m = Meeting.create(committee: c)
      get meeting_path(m.id)
      expect(response).to have_http_status(:success)
    end

    it "can't sign in if meeting ended" do
      m = c.current_meeting
      post end_meeting_path(m.id)
      sign_user_in(u2)
      post sign_in_meeting_path(m.id)
      expect(AttendanceRecord.find_record(m, u2).attended).to eq false
    end
  end
end
