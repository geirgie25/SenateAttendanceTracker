# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the MeetingsHelper. For example:
#
# describe MeetingsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe MeetingsHelper, type: :helper do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'papa', name: 'papi2', password: 'pass2') }
  let(:u2) { User.create(username: 'papa2', name: 'papi2', password: 'pass2') }

  before do
    u2.committees << c
  end

  describe 'Sign-In:' do
    it 'if current meeting, show sign-in if user for committee' do
      m = Meeting.create(committee: c, start_time: Time.zone.now)
      AttendanceRecord.make_records_for(m)
      expect(show_sign_in?(u2, m)).to eq true
    end

    it "if no current meeting but in committee, don't show sign-in" do
      m = Meeting.create(committee: c, start_time: Time.zone.now, end_time: Time.zone.now)
      AttendanceRecord.make_records_for(m)
      expect(show_sign_in?(u2, m)).to eq false
    end

    it "don't show sign in if not in committee" do
      m = Meeting.create(committee: c, start_time: Time.zone.now)
      AttendanceRecord.make_records_for(m)
      expect(show_sign_in?(u, m)).to eq false
    end
  end
end
