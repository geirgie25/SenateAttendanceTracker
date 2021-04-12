# frozen_string_literal: true

module CommitteesHelper
  # returns true if the start meeting button should show
  def show_start_button?(user, committee)
    return !committee&.current_meeting? if user&.heads_committee?(committee)

    false
  end

  # returns true if the end meeting button should show
  def show_end_button?(user, committee)
    return committee&.current_meeting? if user&.heads_committee?(committee)

    false
  end

  # returns true if we should show the sign in notice
  def show_sign_in_notice?(user, committee)
    (
      user&.in_committee?(committee) &&
      committee.current_meeting? &&
      !user&.attended_meeting?(committee.current_meeting)
    ).present?
  end

  # returns true if we should show the excuses link
  def show_committee_excuses_link?(user, committee)
    user&.heads_committee?(committee)
  end

  # returns true if we should show link to users above max absences
  def show_users_above_max_absences_link?(user, committee)
    user&.heads_committee?(committee)
  end

  # returns true if we should show edit committee link
  def show_edit_committee_link?(user, _committee)
    user&.admin?.present?
  end

  # returns true if we should show delete link
  def show_delete_committee_link?(user)
    user&.admin?.present?
  end
end
