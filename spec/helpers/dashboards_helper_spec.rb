# frozen_string_literal: true

require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the CommitteesHelper. For example:
#
# describe DashboardsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe DashboardsHelper, type: :helper do
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'user', name: 'user', password: 'pass') }
  let(:ce) { CommitteeEnrollment.create }

  before do
    ce.committee = c
    ce.user = u
    ce.save
  end

  describe 'Page should ' do
    it 'show yellow warning if user is nearing max absence limit' do
      make_absences(9)
      expect(show_yellow_warning?(12, AttendanceRecord.find_total_absences(ce))).to eq true
    end

    it 'show red warning if user is has reached max absence limit' do
      make_absences(12)
      expect(show_red_warning?(12, AttendanceRecord.find_total_absences(ce))).to eq true
    end

    it 'show red warning if user is has passed max absence limit' do
      make_absences(13)
      expect(show_red_warning?(12, AttendanceRecord.find_total_absences(ce))).to eq true
    end

    it 'not show yellow warning if user is well below max absence limit' do
      make_absences(1)
      expect(show_yellow_warning?(12, AttendanceRecord.find_total_absences(ce))).to eq false
    end

    it 'not show red warning if user is well below max absence limit' do
      make_absences(1)
      expect(show_red_warning?(12, AttendanceRecord.find_total_absences(ce))).to eq false
    end
  end

  private

  def make_absences(number_of_absences)
    number_of_absences.times do
      AttendanceRecord.make_records_for(
        Meeting.create(
          committee: c,
          start_time: Time.zone.now,
          end_time: Time.zone.now
        )
      )
    end
  end
end
