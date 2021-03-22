# frozen_string_literal: true

# default helper methods
module ApplicationHelper
  def human_boolean(boolean)
    boolean ? 'Yes' : 'No'
  end
end
