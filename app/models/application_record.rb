# frozen_string_literal: true

# the model which all other models derive from
class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end
