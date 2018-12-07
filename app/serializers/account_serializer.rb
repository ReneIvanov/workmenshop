class AccountSerializer
  def initialize(account_obj)
    @accounts_array = []
    case 
    when account_obj.is_a?(Account)   #if there are only one account
      @accounts_array << account_obj
    when account_obj.is_a?(ActiveRecord::Relation)  #if there are more users
      account_obj.each do |account|
        @accounts_array << account
      end
    end
  end

  def account_as_json(account)
    account_hash = {}
    account_hash.merge!(public_uid: account.public_uid)
    account_hash.merge!(customer: account.customer)
    account_hash.merge!(workmen: account.workmen)
    account_hash.merge!(admin: account.admin)
    account_hash.merge!(user_id: account.user_id)
    return account_hash
  end

  def as_json
    @json_array = []
    @accounts_array.each do |account|
      account_hash = account_as_json(account)
      @json_array << account_hash
    end
    return @json_array
  end
end
