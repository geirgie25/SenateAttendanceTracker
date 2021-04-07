# frozen_string_literal: true

# default helper methods
module ApplicationHelper
  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end

  # returns true if the given user has committee head
  # permissions for the given committee
  def committee_head_permissions?(user, committee)
    return user.heads_committee?(committee) unless user.nil?

    false
  end
end
