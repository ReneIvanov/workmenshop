class AccountSerializer
  def initialize(account_obj)
    @accounts_array = []
    case account_obj.class.name
    when "ActiveRecord::Relation"  #if there are more accounts
      account_obj.each do |account|
        @accounts_array << account
      end
    when "Account"  #if there are only one account
      @accounts_array << account_obj
    end
  end

  def account_as_json(account)
    account_hash = 
      {
        id: account.id,
        customer: account.customer,
        workmen: account.workmen,
        admin: account.admin,
        user_id: account.user_id
      }
  end

  def as_json
    @json_hash = {accounts: []}
    @accounts_array.each do |account|
      account_hash = account_as_json(account)
      @json_hash[:accounts] << account_hash
    end
    return @json_hash
  end
end
