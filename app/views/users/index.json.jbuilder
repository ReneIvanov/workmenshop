#json.array! @users, partial: 'users/user', as: :user

# 1.possibility==========================
#json.users @users do |user|
#  json.id user.id
#  json.username user.username
#  json.email user.email
#  json.works user.works do |work|
#    json.id work.id
#    json.title work.title
#  end
#  json.all user	
#end
#
#json.accounts @accounts do |account|
#  json.id account.id
#  json.customer account.customer if account.customer
#  json.workmen account.workmen if account.workmen
#  json.admin account.admin if account.admin
#  json.user_id account.user_id
#end

#2.possibility============================
#hash = { author: { name: "Fero" } }
#
#json.users @users do |user|
#  json.id user.id
#  json.(user, :username, :email)
#  #json.username user.username
#  #json.email user.email
#  json.works user.works do |work|
#    json.id work.id
#    json.title work.title
#  end
#  json.all user
#  json.merge! hash	
#end
#
#json.accounts @accounts, :id, :customer, :workmen, :admin, :user_id

#3.possibility==============================

@a = @accounts.last
json.partial! 'users/user', collection: @users, as: :user, locals: { a: @a } #for every user from @users call parital _user.json.jbuilder
