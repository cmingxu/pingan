json.extract! login, :id, :ip, :created_at, :updated_at
json.url login_url(login, format: :json)
