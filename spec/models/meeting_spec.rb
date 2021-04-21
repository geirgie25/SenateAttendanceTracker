# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Meeting, type: :model do
  let(:u) { User.create(name: 'name', username: 'username', password: 'password') }
  let(:c) { Committee.create(committee_name: 'committee') }
  let(:m) { described_class.create(title: 'title', committee: c, start_time: Time.zone.now, end_time: Time.zone.now) }

  it 'user exists in meeting' do
    u.committees << c
    u.save
    AttendanceRecord.create(meeting: m, committee_enrollment: c.committee_enrollments.where(user: u).take,
                            attended: true)
    expect(m.user_exists?(u)).to eq true
  end

  it 'user attended meeting' do
    u.committees << c
    u.save
    AttendanceRecord.create(meeting: m, committee_enrollment: c.committee_enrollments.where(user: u).take,
                            attended: true)
    expect(m.attended_meeting?(u)).to eq true
  end
end
