module SerializersTestHelper
  extend self #tells that all methods will be "class" methods

  def serialize(object)
    case object.class.name
    when "User"
      user_serializer(object)
    when "Account"
      account_serializer(object)
    when "Work"
      work_serializer(object)
    else
      nil
    end
  end

  def user_serializer(user)
    user_hash = {}
    user_hash.merge!(id: user.id)
    user_hash.merge!(username: user.username)
    user_hash.merge!(email: user.email)
    user_hash.merge!(address: user.address)
    user_hash.merge!(telephone: user.telephone)
    user_hash.merge!(account: AccountSerializer.new(user.account).as_json)
    user_hash.merge!(works: WorkSerializer.new(user.works).as_json)
    
    if user.profile_picture.attached?
      user_hash.merge!(profile_picture: user.profile_picture.blob[:filename])
    else
      user_hash.merge!(profile_picture: {}) 
    end

    return user_hash
  end

  def account_serializer(account)
    account_hash = {}
    account_hash.merge!(id: account.id)
    account_hash.merge!(customer: account.customer)
    account_hash.merge!(workmen: account.workmen)
    account_hash.merge!(admin: account.admin)
    account_hash.merge!(user_id: account.user_id)
    return account_hash
  end

  def work_serializer(work)
    work_hash = {}
    work_hash.merge!(id: work.id)
    work_hash.merge!(title: work.title)
    return work_hash
  end
end