# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AttendanceRecord, type: :model do
  let(:c) { Committee.create(committee_name: 'test_naem') }
  let(:m) { Meeting.create(committee: c, start_time: Time.zone.now, title: 'title') }
  let(:u) { User.create(username: 'username', password: 'password', name: 'name') }

  before do
    c.users << u
    c.save
    described_class.make_records_for(m)
  end

  it 'make_records_for and records works' do
    expect(described_class.records(u).first).to be_truthy
  end

  it 'find_record works' do
    expect(described_class.find_record(m, u)).to be_truthy
  end

  it 'set_attended works' do
    described_class.set_attended(m, u, true)
    expect(described_class.records(u).first.attended).to eq true
  end

  it 'find_total_absences' do
    expect(described_class.find_total_absences(u.committee_enrollments)).to eq 1
  end

  it 'find_total_excused_absences with no excuses' do
    expect(described_class.find_total_excused_absences(u.committee_enrollments)).to eq 0
  end

  it 'find_total_excused_absences with one excuse' do
    Excuse.create(attendance_record: described_class.records(u).first, status: 1)
    expect(described_class.find_total_excused_absences(u.committee_enrollments)).to eq 1
  end

  it 'find total_unexcused_absences' do
    expect(described_class.find_total_unexcused_absences(u.committee_enrollments)).to eq 1
  end

  it 'find find_total_absences' do
    expect(described_class.find_total_absences(u.committee_enrollments)).to eq 1
  end

  it 'get_absences works' do
    expect(described_class.get_absences(u).first).to be_truthy
  end
end
