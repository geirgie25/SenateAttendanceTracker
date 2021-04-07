# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:r) { Role.create(role_name: 'Administrator') }
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi', password: 'pass') }

  before do
    u.roles << r
    u.save
  end

  describe 'Index:' do
    it 'get committee index page if not logged in' do
      get(committee_users_url(c.id))
      expect(response).to have_http_status(:success)
    end

    it 'get committee index page if logged in' do
      sign_user_in(u2)
      get(committee_users_url(c.id))
      expect(response).to have_http_status(:success)
    end

    it 'redirect index page if user' do
      sign_user_in(u2)
      get users_path
      expect(response).to have_http_status(:redirect)
    end

    it 'get index page if admin' do
      sign_user_in(u)
      get users_path
      expect(response).to have_http_status(:success)
    end
  end

  describe 'Show User:' do
    it 'show committe user if not logged in' do
      get committee_user_path(c.id, u2.id)
      expect(response).to have_http_status(:success)
    end

    it 'show committe user if logged in' do
      sign_user_in(u2)
      get committee_user_path(c.id, u2.id)
      expect(response).to have_http_status(:success)
    end

    it 'dont show user if user' do
      sign_user_in(u2)
      get user_path(u2.id)
      expect(response).to have_http_status(:redirect)
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

    it 'done create user if username is not unique' do
      sign_user_in(u)
      expect do
        post users_path, params: { user: { name: 'TestName', username: 'papa', password: 'TestPassword' } }
      end.to change(User, :count).by(0)
    end
  end

  describe 'Update User:' do
    it 'dont update user if user' do
      sign_user_in(u2)
      patch user_path(u2.id), params: { id: u2.id, user: { name: 'papi', username: 'NewUsername', password: 'pass' } }
      expect(User.find(u2.id).username).to eq 'papa2'
    end

    it 'update user if admin' do
      sign_user_in(u)
      patch user_path(u2.id), params: { id: u2.id, user: { name: 'papi', username: 'NewUsername', password: 'pass' } }
      expect(User.find(u2.id).username).to eq 'NewUsername'
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
  end
end
