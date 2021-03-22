# frozen_string_literal: true

class MeetingsController < ApplicationController
  skip_before_action :admin_authorized, only: %i[create end]
  def create
    @committee = Committee.find(params[:committee_id])
    if create_meeting_valid(@committee)
      @meeting = Meeting.new(committee: @committee, title: new_meeting_title(params[:meeting_title]))
      @meeting.start_meeting
      @meeting.save
      AttendanceRecord.make_records_for(@meeting)
    end
    redirect_to committee_path(@committee.id)
  end

  def end
    @committee = Committee.find(params[:committee_id])
    if end_meeting_valid(@committee)
      @meeting = Meeting.find(params[:id])
      @meeting.end_meeting
      @meeting.save
    end
    redirect_to committee_path(@committee.id)
  end

  private

  def new_meeting_title(curr_title)
    return Time.zone.now.to_formatted_s(:short) if curr_title.blank?

    curr_title
  end

  def create_meeting_valid(committee)
    current_user && committee && !committee.current_meeting? && current_user.heads_committee?(committee)
  end

  def end_meeting_valid(committee)
    current_user && committee && committee.current_meeting? && current_user.heads_committee?(committee)
  end
end
