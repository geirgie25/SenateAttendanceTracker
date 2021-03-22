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

  describe 'Start Meeting' do
    it "can't start if not logged in" do
      post meeting_new_path, params: { committee_id: c.id, meeting_title: 'test_meeting1' }
      expect(response).to redirect_to('/login')
    end

    it "can't start if don't have permission" do
      post '/login', params: { username: u2.username, password: u2.password }
      post meeting_new_path, params: { committee_id: c.id, meeting_title: 'test_meeting2' }
      expect(c.current_meeting?).to eq false
    end

    it 'starts if have permission' do
      post '/login', params: { username: u.username, password: u.password }
      post meeting_new_path, params: { committee_id: c.id, meeting_title: 'test_meeting3' }
      expect(c.current_meeting?).to eq true
    end
  end

  describe 'End Meeting' do
    let(:m) { Meeting.create(committee: c, title: 'test_meeting', start_time: Time.zone.now) }

    it "can't end if not logged in" do
      post end_meeting_path(m.id), params: { committee_id: c.id }
      expect(response).to redirect_to('/login')
    end

    it "can't end if don't have role" do
      post '/login', params: { username: u2.username, password: u2.password }
      post end_meeting_path(m.id), params: { committee_id: c.id }
      expect(c.current_meeting?).to eq true
    end

    it 'ends if have role' do
      post '/login', params: { username: u.username, password: u.password }
      post end_meeting_path(m.id), params: { committee_id: c.id }
      expect(c.current_meeting?).to eq false
    end
  end

  describe 'Meeting Title' do
    before do
      post '/login', params: { username: u.username, password: u.password }
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
end
