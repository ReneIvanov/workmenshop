class UserSerializer
  def initialize(user_obj)
    @users_array = []
    case user_obj.class.name
    when "ActiveRecord::Relation"  #if there are more users
      user_obj.each do |user|
        @users_array << user
      end
    when "User"  #if there are only one users
      @users_array << user_obj
    end
  end

  def user_as_json(user)
    user_hash = 
      {
        username: user.username,
        email: user.email
      }
  end

  def as_json
    @json_hash = {users: []}
    @users_array.each do |user|
      user_hash = user_as_json(user)
      @json_hash[:users] << user_hash
    end
    return @json_hash
  end
end
