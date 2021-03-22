# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CommitteesHelper. For example:
#
# describe CommitteesHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe CommitteesHelper, type: :helper do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:r) { Role.create(role_name: 'TestCommitteeHead') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi2', password: 'pass2') }

  before do
    c.roles << r
    c.save
    u.roles << r
    u.save
  end

  describe 'start meeting helper' do
    it 'show if user has role' do
      expect(show_start_button?(u, c)).to eq true
    end

    it "don't show if not role" do
      expect(show_start_button?(u2, c)).to eq false
    end

    it "don't show if current meeting for committee" do
      Meeting.create(start_time: Time.zone.now, committee: c)
      expect(show_start_button?(u, c)).to eq false
    end

    it 'show if meeting ended' do
      m = Meeting.create(start_time: Time.zone.now, committee: c)
      m.end_meeting
      m.save
      expect(show_start_button?(u, c)).to eq true
    end
  end

  describe 'end meeting helper' do
    it 'show if user has role' do
      Meeting.create(start_time: Time.zone.now, committee: c)
      expect(show_end_button?(u, c)).to eq true
    end

    it "don't show if not role" do
      Meeting.create(start_time: Time.zone.now, committee: c)
      expect(show_end_button?(u2, c)).to eq false
    end

    it "don't show if no current meeting for committee" do
      m = Meeting.create(start_time: Time.zone.now, committee: c)
      m.end_meeting
      m.save
      expect(show_end_button?(u, c)).to eq false
    end
  end
end
