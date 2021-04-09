# frozen_string_literal: true

class MeetingsController < ApplicationController
  skip_before_action :user_authorized, only: %i[index show]
  skip_before_action :admin_authorized, only: %i[index create end show sign_in]

  def index
    @meetings = filter_meetings
  end

  def create
    committee = Committee.find(params[:committee_id])
    if !committee.current_meeting? && committee_head_permissions?(committee)
      AttendanceRecord.make_records_for(
        Meeting.create(
          committee: committee,
          title: new_meeting_title(params[:meeting_title]),
          start_time: Time.zone.now
        )
      )
    end
    redirect_to committee_path(committee.id)
  end

  def show
    @meeting = Meeting.find(params[:id])
  end

  def end
    meeting = Meeting.find(params[:id])
    if meeting.currently_meeting? && committee_head_permissions?(meeting.committee)
      meeting.update(end_time: Time.zone.now)
    end
    redirect_to committee_path(meeting.committee.id)
  end

  def sign_in
    meeting = Meeting.find(params[:id])

    if meeting.currently_meeting? && current_user&.in_committee?(meeting.committee)
      record = AttendanceRecord.find_record(meeting, current_user)
      record&.update(attended: true)
    end
    redirect_to committee_path(meeting.committee.id)
  end

  private

  def filter_meetings
    return Committee.find(params[:committee_id]).meetings if params[:committee_id].present?

    Meeting.all
  end

  def committee_head_permissions?(committee)
    current_user&.heads_committee?(committee)
  end

  def new_meeting_title(curr_title)
    return Time.zone.now.to_formatted_s(:short) if curr_title.blank?

    curr_title
  end
end
