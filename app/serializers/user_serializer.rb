class UserSerializer
  def initialize(user_obj)
    @user_obj = user_obj
  end

  def as_json  #serializer method
    { 
      username: @user_obj.username,
      email: @user_obj.email, 
      account: AccountSerializer.new(@user_obj.account).as_json
    }
  end
end
