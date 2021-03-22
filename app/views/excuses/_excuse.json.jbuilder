# frozen_string_literal: true

json.extract! excuse, :reason
json.url excuse_url(excuse, format: :json)
