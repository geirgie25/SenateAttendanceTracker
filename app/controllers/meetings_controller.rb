# frozen_string_literal: true

class MeetingsController < ApplicationController
  skip_before_action :user_authorized, only: %i[index show]
  skip_before_action :admin_authorized, only: %i[index create end show sign_in]
  before_action :set_meeting, only: %i[show sign_in]
  before_action :set_record, only: %i[show sign_in]

  # gets a list of meetings for a committee
  def index
    @meetings = filter_meetings
  end

  # creates a meeting. aka start a sign in session
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
      redirect_to committee_path(committee.id), notice: 'Started Meeting Sign In'
    else
      redirect_to committee_path(committee.id), notice: 'Error Starting Meeting Sign In'
    end
  end

  # show a specific meeting
  def show
    @meeting = Meeting.find(params[:id])
    @records = AttendanceRecord.for_meeting(@meeting.id)
  end

  # end a meeting aka end a sign in
  def end
    meeting = Meeting.find(params[:id])
    if meeting.currently_meeting? && committee_head_permissions?(meeting.committee)
      meeting.update(end_time: Time.zone.now)
      redirect_to committee_path(meeting.committee.id), notice: 'Ended Meeting Sign In'
    else
      redirect_to committee_path(meeting.committee.id), notice: 'Error Ending Meeting Sign In'
    end
  end

  # signs the current user in
  def sign_in
    if @meeting.currently_meeting? && current_user&.in_committee?(@meeting.committee)
      @meeting.update(meeting_params)
      @record&.update(attended: true)
      redirect_to committee_path(@meeting.committee.id), notice: "Signed in to Meeting #{@meeting.title}"
    else
      redirect_to committee_path(@meeting.committee.id), notice: 'Error Signing in to Meeting'
    end
  end

  private

  # permits the meeting parameters
  def meeting_params
    params.require(:meeting).permit(attendance_records_attributes: %i[id attendance_type])
  end

  # filters the meeting by commtteee id
  def filter_meetings
    return Committee.find(params[:committee_id]).meetings if params[:committee_id].present?

    Meeting.all
  end

  # returns true if current user has committee head permissions
  def committee_head_permissions?(committee)
    current_user&.heads_committee?(committee)
  end

  # gets a formatted title for a committee if one isn't set
  def new_meeting_title(curr_title)
    return Time.zone.now.to_formatted_s(:short) if curr_title.blank?

    curr_title
  end

  def set_meeting
    @meeting = Meeting.find(params[:id])
  end

  def set_record
    @record = AttendanceRecord.find_record(@meeting, current_user)
  end
end
