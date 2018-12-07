class AccountPolicy < ApplicationPolicy
  def initialize(account_obj)
    @account_obj = account_obj
  end

  def can_be_seen_by(user_obj)
    policy(user_obj).is_admin || @account_obj.user == user_obj
  end
end