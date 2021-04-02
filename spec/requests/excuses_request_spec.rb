# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Excuses', type: :request do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'user', name: 'user', password: 'pass') }
  let(:ce) { CommitteeEnrollment.create }
  let(:m) { Meeting.create(title: 'TestMeeting', start_time: Time.zone.now, end_time: Time.zone.now) }
  let(:ar) { AttendanceRecord.create(attended: false) }

  before do
    m.committee = c
    m.save
    ce.committee = c
    ce.user = u
    ce.save
    ar.meeting = m
    ar.committee_enrollment = ce
    ar.save
  end

  describe 'Committees Index:' do
    it 'redirect index page if user' do
      sign_user_in(u)
      get committee_excuses_url(c.id)
      expect(response).to have_http_status(:redirect)
    end

    it 'get index page if committee head' do
      make_committee_head(u)
      get(committee_excuses_url(c.id))
      expect(response).to have_http_status(:success)
    end

    it 'redirect index page if admin' do
      make_admin(u)
      get committee_excuses_url(c.id)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'My Excuses:' do
    it 'get my excuses page if user' do
      sign_user_in(u)
      get excuses_my_excuses_path
      expect(response).to have_http_status(:success)
    end

    it 'redirect my excuses page if admin' do
      make_admin(u)
      get excuses_my_excuses_path
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'Show Excuse:' do
    it 'dont show if user doesnt have permissions' do
      u1 = User.create(username: 'user1', name: 'user1', password: 'pass1')
      e = create_excuse(ar)
      sign_user_in(u1)
      get excuse_path(e.id)
      expect(response).to have_http_status(:redirect)
    end

    it 'show if user has permissions' do
      e = create_excuse(ar)
      sign_user_in(u)
      get excuse_path(e.id)
      expect(response).to have_http_status(:success)
    end

    it 'show if user is admin' do
      make_admin(u)
      expect(u.admin?).to eq true
    end

    it 'show if user is committee head' do
      make_committee_head(u)
      expect(u.heads_committee?(c)).to eq true
    end
  end

  describe 'New Excuse:' do
    it 'get new excuse page if user has permissions' do
      sign_user_in(u)
      get new_excuse_path, params: { attendance_record_id: ar.id }
      expect(response).to have_http_status(:success)
    end

    it 'dont get new excuse page if user does not have permissions' do
      u1 = User.create(username: 'user1', name: 'user1', password: 'pass1')
      sign_user_in(u1)
      get new_excuse_path, params: { attendance_record_id: ar.id }
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'Edit Committee Excuse:' do
    it 'redirect edit page if user' do
      e = create_excuse(ar)
      sign_user_in(u)
      get edit_committee_excuse_path(c.id, e.id)
      expect(response).to have_http_status(:redirect)
    end

    it 'get edit page if committee head' do
      make_committee_head(u)
      e = create_excuse(ar)
      get edit_committee_excuse_path(c.id, e.id)
      expect(response).to have_http_status(:success)
    end

    it 'redirect edit page if admin' do
      make_admin(u)
      e = create_excuse(ar)
      get edit_committee_excuse_path(c.id, e.id)
      expect(response).to have_http_status(:redirect)
    end
  end

  describe 'Create Excuse:' do
    it 'create excuse if user' do
      sign_user_in(u)
      expect do
        post excuses_path,
             params: { excuse: { reason: 'TestReason', attendance_record_id: ar.id } }
      end.to change(Excuse, :count).by(1)
    end

    it 'dont create excuse if admin' do
      make_admin(u)
      expect do
        post excuses_path,
             params: { excuse: { reason: 'TestReason', attendance_record_id: ar.id } }
      end.to change(Excuse, :count).by(0)
    end

    it 'set status to Pending when created' do
      sign_user_in(u)
      post excuses_path, params: { excuse: { reason: 'TestReason', attendance_record_id: ar.id } }
      expect(Excuse.last.status).to eq 'Pending'
    end
  end

  describe 'Update Excuse:' do
    it 'dont update if user' do
      e = create_excuse(ar)
      sign_user_in(u)
      patch excuse_path(e.id), params: { id: e.id, excuse: { status: 'Approved' } }
      expect(Excuse.find(e.id).status).to eq 'Pending'
    end

    it 'update if committee head' do
      make_committee_head(u)
      e = create_excuse(ar)
      patch excuse_path(e.id), params: { id: e.id, excuse: { status: 'Approved' } }
      expect(Excuse.find(e.id).status).to eq 'Approved'
    end

    it 'dont update if admin role' do
      make_admin(u)
      e = create_excuse(ar)
      patch excuse_path(e.id), params: { id: e.id, excuse: { status: 'Approved' } }
      expect(Excuse.find(e.id).status).to eq 'Pending'
    end
  end

  describe 'Delete Excuse:' do
    it 'dont delete if user' do
      e = create_excuse(ar)
      sign_user_in(u)
      delete committee_excuse_path(c.id, e.id)
      expect(Excuse.exists?(e.id)).to eq true
    end

    it 'delete if committee head' do
      make_committee_head(u)
      e = create_excuse(ar)
      delete committee_excuse_path(c.id, e.id)
      expect(Excuse.exists?(e.id)).to eq false
    end

    it 'dont delete if admin role' do
      make_admin(u)
      e = create_excuse(ar)
      delete committee_excuse_path(c.id, e.id)
      expect(Excuse.exists?(e.id)).to eq true
    end
  end

  private

  def make_committee_head(user)
    r = Role.create(role_name: 'TestCommitteeHead')
    user.roles << r
    user.save
    c.roles << r
    c.save
    sign_user_in(u)
  end

  def make_admin(user)
    r = Role.create(role_name: 'Administrator')
    user.roles << r
    user.save
    sign_user_in(user)
  end

  def create_excuse(record)
    e = Excuse.create(reason: 'TestReason')
    e.attendance_record = record
    e.save
    e
  end
end
