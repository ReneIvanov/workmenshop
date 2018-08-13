json.extract! person, :id, :name, :address, :workmen, :customer, :image_url, :email, :telephone, :created_at, :updated_at
json.url person_url(person, format: :json)
