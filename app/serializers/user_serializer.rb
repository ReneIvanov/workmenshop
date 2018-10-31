class UserSerializer
  #def initialize(user_obj)
  #  @user_obj = user_obj
  #end
  
  def user_as_json(user)
    user_hash = 
      {
        username: user.username,
        email: user.email
      }
  end

  def as_json(users_obj)
    @json_hash = {users: []}

    if users_obj.class.name == "ActiveRecord::Relation"
      build_hash_from_relation(users_obj)
    elsif users_obj.class.name == "User"
      build_hash_from_model(users_obj)
    else
      return @json_hash
    end
  end

  def build_hash_from_relation(users)
    users.each do |user|
      user_hash = user_as_json(user)
      @json_hash[:users] << user_hash
    end
    return @json_hash
  end

  def build_hash_from_model(user)
    user_hash = user_as_json(user)
      @json_hash[:users] << user_hash
      return @json_hash
  end
end
