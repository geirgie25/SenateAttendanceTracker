# frozen_string_literal: true

json.array! @excuses, partial: 'excuses/excuse', as: :excuse
