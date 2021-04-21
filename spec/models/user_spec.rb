# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  let(:u) { described_class.create(name: 'name', username: 'username', password: 'password') }
  let(:r) { Role.create(role_name: 'Administrator') }
  let(:c) { Committee.create(committee_name: 'committee') }
  let(:r2) { Role.create(role_name: 'head', committees: [c]) }
  let(:m) { Meeting.create(title: 'title', committee: c, start_time: Time.zone.now, end_time: Time.zone.now) }

  it 'not admin' do
    expect(u.admin?).to eq false
  end

  it 'admin' do
    u.roles << r
    u.save
    expect(u.admin?).to eq true
  end

  it "doesn't head committee" do
    expect(u.heads_committee?(c)).to eq false
  end

  it 'heads committee' do
    u.roles << r2
    u.save
    expect(u.heads_committee?(c)).to eq true
  end

  it 'in committee' do
    u.committees << c
    u.save
    expect(u.in_committee?(c)).to eq true
  end

  it 'attended meeting' do
    u.committees << c
    u.save
    AttendanceRecord.create(meeting: m, committee_enrollment: c.committee_enrollments.where(user: u).take,
                            attended: true)
    expect(u.attended_meeting?(m)).to eq true
  end

  it 'not in meeting' do
    expect(u.attended_meeting?(m)).to eq false
  end

  it 'attended false' do
    u.committees << c
    u.save
    AttendanceRecord.create(meeting: m, committee_enrollment: c.committee_enrollments.where(user: u).take,
                            attended: false)
    expect(u.attended_meeting?(m)).to eq false
  end

  it 'get committee enrollment' do
    u.committees << c
    u.save
    expect(u.get_committee_enrollment(c)).to eq c.committee_enrollments.where(user: u).first
  end

  it 'above max absences' do
    u.committees << c
    u.save
    expect(u.above_max_absences?(c)).to eq false
  end
end
