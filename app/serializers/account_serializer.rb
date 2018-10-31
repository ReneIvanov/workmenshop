class AccountSerializer
  def initialize(account_obj)
    @account_obj = account_obj
  end

  def as_json
    {
      id: @account_obj.id,
      user_id: @account_obj.user_id,
      workmen: @account_obj.workmen,
      customer: @account_obj.customer,
      admin: @account_obj.admin
    }
  end
end
