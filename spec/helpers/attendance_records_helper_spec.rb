# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CommitteesHelper. For example:
#
# describe AttendanceRecordsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe AttendanceRecordsHelper, type: :helper do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'user', name: 'user', password: 'pass') }
  let(:ce) { CommitteeEnrollment.create }

  before do
    ce.committee = c
    ce.user = u
    ce.save
  end

  describe 'Page should ' do
    it 'show excuse link if excuse exists' do
      m = Meeting.create(title: 'TestMeeting', start_time: Time.zone.now, end_time: Time.zone.now, committee_id: c.id)
      ar = AttendanceRecord.create(attended: false, committee_enrollment_id: ce.id, meeting_id: m.id)
      Excuse.create(reason: 'TestReason', attendance_record_id: ar.id)
      expect(show_excuse_link?(ar)).to eq true
    end

    it 'not show excuse link if excuse does not exist' do
      m = Meeting.create(title: 'TestMeeting', start_time: Time.zone.now, end_time: Time.zone.now, committee_id: c.id)
      ar = AttendanceRecord.create(attended: false, committee_enrollment_id: ce.id, meeting_id: m.id)
      expect(show_excuse_link?(ar)).to eq false
    end
  end
end
