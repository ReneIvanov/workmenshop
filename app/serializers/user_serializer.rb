class UserSerializer
  #def initialize(user_obj)
  #  @user_obj = user_obj
  #end

  def as_json(users)
    @users = users
    @json_hash = {users: []}

    @users.each do |user|
      user_hash = 
        {
          username: user.username,
          email: user.email
        }
      @json_hash[:users] << user_hash
    end
    return @json_hash
  end
end
