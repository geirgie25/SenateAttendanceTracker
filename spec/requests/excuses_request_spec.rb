# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Excuses', type: :request do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:r) { Role.create(role_name: 'TestCommitteeHead') }
  let(:r2) { Role.create(role_name: 'Administrator') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi2', password: 'pass2') }

  before do
    c.roles << r
    c.save
    u.roles << r
    u.save
  end

  # make sure we can get to committee page
  it 'get show page' do
    get committee_path(c.id)
    expect(response).to have_http_status(:success)
  end

  describe 'Update Committee:' do
    it 'dont update even if committee head' do
      sign_user_in(u)
      patch committee_path(c.id), params: { id: c.id, committee: { committee_name: 'UpdatedName' } }
      expect(Committee.find(c.id).committee_name).to eq 'TestCommittee'
    end

    it 'update if admin role' do
      u2.roles << r2
      u2.save
      sign_user_in(u2)
      patch committee_path(c.id), params: { id: c.id, committee: { committee_name: 'UpdatedName' } }
      expect(Committee.find(c.id).committee_name).to eq 'UpdatedName'
    end

    it "don't update without permissions" do
      sign_user_in(u2)
      patch committee_path(c.id), params: { id: c.id, committee: { committee_name: 'UpdatedName' } }
      expect(Committee.find(c.id).committee_name).to eq 'TestCommittee'
    end

    it 'update users in committee' do
      u2.roles << r2
      u2.save
      sign_user_in(u2)
      patch committee_path(c.id), params: { committee: { committee_name: 'UpdatedName', user_ids: [u.id] } }
      expect(Committee.find(c.id).users.first).to eq u
    end
  end

  describe 'Edit Committee:' do
    it 'dont go to page if head' do
      sign_user_in(u)
      get edit_committee_path(c.id)
      expect(response).to have_http_status(:redirect)
    end

    it 'go to page if admin' do
      u2.roles << r2
      u2.save
      sign_user_in(u2)
      get edit_committee_path(c.id)
      expect(response).to have_http_status(:success)
    end

    it "don't go to page without permission" do
      sign_user_in(u2)
      get edit_committee_path(c.id)
      expect(response).to have_http_status(:redirect)
    end

    it "don't go to page without logged in" do
      get edit_committee_path(c.id)
      expect(response).to have_http_status(:redirect)
    end
  end
end
