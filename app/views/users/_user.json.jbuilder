#json.extract! users, :id, :username, :email 
#json.url user_url(user, format: :json)


json.id user.id
json.username user.username
json.email user.email
json.works user.works do |work|
  json.id work.id
  json.title work.title
end

json.a @a.id	
