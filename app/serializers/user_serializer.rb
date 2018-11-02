class UserSerializer
  def initialize(user_obj)
    @users_array = []
    case 
    when user_obj.is_a?(User)   #if there are only one user
      @users_array << user_obj
    when user_obj.is_a?(ActiveRecord::Relation)  #if there are more users
      user_obj.each do |user|
        @users_array << user
      end
    end
  end

  def user_as_json(user)
    user_hash = {} 
    user_hash.merge!(username: user.username)
    user_hash.merge!(email: user.email)
    user_hash.merge!(address: user.address) if !user.address.empty?
    user_hash.merge!(telephone: user.telephone) if !user.telephone.empty?
    user_hash.merge!(account: AccountSerializer.new(user.account).as_json)
    user_hash.merge!(works: WorkSerializer.new(user.works).as_json)
    return user_hash
  end

  def as_json
    @json_array = []
    @users_array.each do |user|
      user_hash = user_as_json(user)
      @json_array << user_hash
    end
    return @json_array
  end
end
