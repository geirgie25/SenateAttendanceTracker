<<<<<<< HEAD
=======
# frozen_string_literal: true

>>>>>>> main
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
<<<<<<< HEAD
  pending "add some examples to (or delete) #{__FILE__}"
=======
  let(:c) { Committee.create(committee_name: 'TestCommittee') }
  let(:r) { Role.create(role_name: 'TestCommitteeHead') }
  let(:u) { User.create(username: 'papa', name: 'papi', password: 'pass') }
  let(:u2) { User.create(username: 'papa2', name: 'papi2', password: 'pass2') }

  before do
    c.roles << r
    c.users << u2
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
      Meeting.create(start_time: Time.zone.now, committee: c, end_time: Time.zone.now)
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
      Meeting.create(start_time: Time.zone.now, committee: c, end_time: Time.zone.now)
      expect(show_end_button?(u, c)).to eq false
    end
  end

  describe 'sign in helper' do
    it 'current meeting and user in committe' do
      AttendanceRecord.make_records_for(Meeting.create(start_time: Time.zone.now, committee: c))
      expect(show_sign_in_notice?(u2, c)).to eq true
    end

    it 'user in committee no current meeting' do
      AttendanceRecord.make_records_for(Meeting.create(start_time: Time.zone.now, committee: c,
                                                       end_time: Time.zone.now))
      expect(show_sign_in_notice?(u2, c)).to eq false
    end

    it 'user not in committee current meeting' do
      AttendanceRecord.make_records_for(Meeting.create(start_time: Time.zone.now, committee: c))
      expect(show_sign_in_notice?(u, c)).to eq false
    end

    it 'user not logged in current meeting' do
      AttendanceRecord.make_records_for(Meeting.create(start_time: Time.zone.now, committee: c))
      expect(show_sign_in_notice?(nil, c)).to eq false
    end
  end

  describe 'show edit link helper' do
    it 'committee head' do
      expect(show_edit_committee_link?(u)).to eq false
    end

    it 'admin' do
      r2 = Role.create(role_name: 'Administrator')
      u2.roles << r2
      u2.save
      expect(show_edit_committee_link?(u2)).to eq true
    end

    it 'no role' do
      expect(show_edit_committee_link?(u2)).to eq false
    end

    it 'not logged in' do
      expect(show_edit_committee_link?(nil)).to eq false
    end
  end
>>>>>>> main
end
