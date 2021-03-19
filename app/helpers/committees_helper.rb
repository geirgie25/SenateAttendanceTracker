# frozen_string_literal: true

module CommitteesHelper
  # returns true if the given user has committee head
  # permissions for the given committee
  def committee_head_permissions?(user, committee)
    return user.heads_committee?(committee) unless user.nil?

    false
  end

  # returns true if the start meeting button should show
  def show_start_button?(user, committee)
    return !committee.current_meeting? if committee_head_permissions?(user, committee)

    false
  end

  # returns true if the end meeting button should show
  def show_end_button?(user, committee)
    return committee.current_meeting? if committee_head_permissions?(user, committee)

    false
  end

  def show_signin_notice?(user, committee)
    return committee_head_permissions?(user, committee) && user.in_committee?(committee) unless user.nil?

    false
  end

  def 
end
