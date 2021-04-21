# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboards', type: :request do
  let(:admin) { User.create(username: 'admin', password: 'password', name: 'admin') }
  let(:user) { User.create(username: 'user', password: 'password', name: 'user') }
  let(:role) { Role.create(role_name: 'admin') }

  before do
    admin.roles << role
    admin.save
  end

  describe 'User Login:' do
    it 'log in works' do
      post '/login', params: { username: user.username, password: user.password }
      expect(response).to redirect_to(controller: 'dashboards', action: 'user')
    end
  end

  describe 'Admin Login:' do
    it 'log in works' do
      post '/login', params: { username: admin.username, password: admin.password }
      expect(response).to redirect_to(controller: 'dashboards', action: 'admin')
    end
  end

  describe 'Help Page:' do
    it 'help page works' do
      get '/help'
      expect(response).to render_template(:help)
    end
  end
  
end
