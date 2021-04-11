# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:r) { Role.create(role_name: 'Administrator') }
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u1) { User.create(username: 'papa1', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi', password: 'pass') }

  before do
    u.roles << r
    u.save
  end

  describe 'Users Index:' do
    it 'get committee users index page if not logged in' do
      get(users_url(committee_id: c.id))
      expect(response).to have_http_status(:success)
    end

    it 'get committee user index page if logged in' do
      sign_user_in(u2)
      get(users_url(committee_id: c.id))
      expect(response).to have_http_status(:success)
    end

    it 'get users index page if user' do
      sign_user_in(u2)
      get users_path
      expect(response).to have_http_status(:success)
    end

    it 'get users index page if admin' do
      sign_user_in(u)
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Show User:' do
    it 'show user if user' do
      sign_user_in(u2)
      get user_path(u2.id)
      expect(response).to have_http_status(:success)
    end

    it 'show user if admin' do
      sign_user_in(u)
      get user_path(u2.id)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'New User:' do
    it 'redirect new user page if user' do
      sign_user_in(u2)
      get new_user_path, params: { name: 'TestName', username: 'TestUsername', password: 'TestPassword' }
      expect(response).to have_http_status(:redirect)
    end

    it 'get new user page if user is admin' do
      sign_user_in(u)
      get new_user_path, params: { name: 'TestName', username: 'TestUsername', password: 'TestPassword' }
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Edit Users:' do
    it 'add role' do
      sign_user_in(u)
      patch user_path(u2.id),
            params: { user: { username: 'papa2', name: 'papi', password: 'pass', role_ids: [r.id] } }
      expect(User.find(u2.id).roles.first).to eq r
    end

    it 'remove role' do
      u2.roles << r
      sign_user_in(u)
      patch user_path(u2.id),
            params: { user: { username: 'papa2', name: 'papi', password: 'pass', role_ids: [] } }
      expect(User.find(u2.id).roles.first).to eq nil
    end
  end

  describe 'Create User:' do
    it 'dont create user if user' do
      sign_user_in(u2)
      expect do
        post users_path,
             params: { user: { name: 'TestName', username: 'TestUsername', password: 'TestPassword' } }
      end.to change(User, :count).by(0)
    end

    it 'create user if admin' do
      sign_user_in(u)
      expect do
        post users_path,
             params: { user: { name: 'TestName', username: 'TestUsername', password: 'TestPassword' } }
      end.to change(User, :count).by(1)
    end

    it 'dont create user if form not complete' do
      sign_user_in(u)
      expect do
        post users_path, params: { user: { name: '', username: '', password: 'TestPassword' } }
      end.to change(User, :count).by(0)
    end

    it 'dont create user if username is not unique' do
      sign_user_in(u)
      expect do
        post users_path, params: { user: { name: 'TestName', username: 'papa', password: 'TestPassword' } }
      end.to change(User, :count).by(0)
    end

    it 'if user is assigned committee head role add user to committee' do
      sign_user_in(u)
      r1 = make_committee_head_role(c)
      post users_path, params: { user: { name: '1', username: '1', password: '1', role_ids: [r1.id] } }
      u = User.last
      expect(CommitteeEnrollment.where(user: u).and(CommitteeEnrollment.where(committee: c)).present?).to eq true
    end
  end

  describe 'Update User:' do
    it 'dont update user if user id does not match' do
      sign_user_in(u1)
      patch user_path(u2.id), params: { id: u2.id, user: { name: 'papi', username: 'NewUsername', password: 'pass' } }
      expect(User.find(u2.id).username).to eq 'papa2'
    end

    it 'update user if user id matches' do
      sign_user_in(u2)
      patch user_path(u2.id), params: { id: u2.id, user: { name: 'papi', username: 'NewUsername', password: 'pass' } }
      expect(User.find(u2.id).username).to eq 'NewUsername'
    end

    it 'if user is assigned committee head role and user isnt part of committee, should be signed up for committee' do
      sign_user_in(u)
      r1 = make_committee_head_role(c)
      patch user_path(u2.id), params: { id: u2.id, user: { password: 'pass', role_ids: [r1.id] } }
      expect(CommitteeEnrollment.where(user: u2).and(CommitteeEnrollment.where(committee: c)).present?).to eq true
    end

    it 'if user is assigned committee head role and user is a part of committee, shouldnt be signed up for committee' do
      sign_user_in(u)
      CommitteeEnrollment.create(user: u2, committee: c)
      r1 = make_committee_head_role(c)
      patch user_path(u2.id), params: { id: u2.id, user: { password: 'pass', role_ids: [r1.id] } }
      expect(CommitteeEnrollment.where(user: u2).and(CommitteeEnrollment.where(committee: c)).count).to eq 1
    end

    it 'dont update if invalid' do
      sign_user_in(u)
      patch user_path(u2.id), params: { id: u2.id, user: { name: 'papi', username: 'papa', password: 'pass' } }
      expect(User.find(u2.id).username).to eq 'papa2'
    end
  end

  describe 'Delete User:' do
    it 'dont delete user if user' do
      sign_user_in(u2)
      delete user_path(u2.id)
      expect(User.exists?(u2.id)).to eq true
    end

    it 'delete user if admin' do
      sign_user_in(u)
      delete user_path(u2.id)
      expect(User.exists?(u2.id)).to eq false
    end

    it 'delete committee enrollments when parent user is deleted' do
      sign_user_in(u)
      ce = CommitteeEnrollment.create(user: u2, committee: c)
      delete user_path(u2.id)
      expect(CommitteeEnrollment.exists?(ce.id)).to eq false
    end
  end

  private

  def make_committee_head_role(committee)
    r = Role.create(role_name: "#{committee.committee_name} Head")
    committee.roles << r
    committee.save
    r
  end
end
