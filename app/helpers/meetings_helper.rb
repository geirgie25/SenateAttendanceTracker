# frozen_string_literal: true

module MeetingsHelper
  # returns true if we should show the sign in part of a meeting
  def show_sign_in?(user, meeting)
    unless user.nil?
      return meeting.currently_meeting? && user.in_committee?(meeting.committee) && !user.attended_meeting?(meeting)
    end

    false
  end
end
