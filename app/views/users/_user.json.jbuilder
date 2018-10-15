json.extract! user, :id, :name, :address, :workmen, :customer, :image_url, :email, :telephone, :created_at, :updated_at
json.url user_url(user, format: :json)
