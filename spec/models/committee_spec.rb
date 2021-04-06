# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Committee, type: :model do
  let(:c) { described_class.create(committee_name: 'TestCommittee') }
  let(:u) { User.create(username: 'user', name: 'user', password: 'pass') }

  describe 'Committee Defaults:' do
    it 'committee default max combined absences should be 11' do
      expect(c.max_combined_absences).to eq 11
    end

    it 'committee default max excused absences should be 11' do
      expect(c.max_excused_absences).to eq 11
    end

    it 'committee default max unexcused absences should be 11' do
      expect(c.max_unexcused_absences).to eq 6
    end
  end

  describe 'Get User Committees Absence Totals:' do
    it '3 committees with default max combined absences should have total of 33' do
      3.times do
        c1 = described_class.create(committee_name: 'Test')
        CommitteeEnrollment.create(committee_id: c1.id, user_id: u.id)
      end
      expect(described_class.get_max_combined_absences_for_all_user_committees(u)).to eq 33
    end

    it '4 committees with default max excused absences should have total of 44' do
      4.times do
        c1 = described_class.create(committee_name: 'Test')
        CommitteeEnrollment.create(committee_id: c1.id, user_id: u.id)
      end
      expect(described_class.get_max_excused_absences_for_all_user_committees(u)).to eq 44
    end

    it '5 committees with default max excused absences should have total of 30' do
      5.times do
        c1 = described_class.create(committee_name: 'Test')
        CommitteeEnrollment.create(committee_id: c1.id, user_id: u.id)
      end
      expect(described_class.get_max_unexcused_absences_for_all_user_committees(u)).to eq 30
    end
  end
end
