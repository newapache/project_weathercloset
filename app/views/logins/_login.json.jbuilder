json.extract! login, :id, :title, :content, :created_at, :updated_at
json.url login_url(login, format: :json)
