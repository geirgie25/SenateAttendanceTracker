json.extract! user, :name, :username, :password
json.url user_url(user, format: :json)
