# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Committees', type: :request do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:r) { Role.create(role_name: 'TestCommitteeHead') }

  before do
    c.roles << r
    c.save
  end

  # make sure we can get to committee page
  it 'returns https success' do
    get committee_path(c.id)
    expect(response).to have_http_status(:success)
  end
end
