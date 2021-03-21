# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:r) { Role.create(role_name: 'Administrator') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi', password: 'pass') }

  before do
    u.roles << r
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
end
