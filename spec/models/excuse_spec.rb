# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Excuse, type: :model do
  let(:c) { Committee.create(committee_name: 'test_naem') }
  let(:m) { Meeting.create(committee: c, start_time: Time.zone.now, title: 'title') }
  let(:ar) { AttendanceRecord.create(meeting: m) }
  let(:e) { described_class.create(attendance_record: ar) }

  it 'excuse default status should be pending' do
    expect(e.Pending?).to eq true
  end

  it 'excuse status should update properly' do
    e.Approved!
    expect(e.Approved?).to eq true
  end
end
