class UserPolicy < ApplicationPolicy
  def initialize(user_obj)
    @user_obj = user_obj
  end

  def has_account
    @user_obj.account.is_a? Account #if user has account
  end

  def is_admin
    if has_account
      @user_obj.account.admin == true
    else
      false
    end
  end

  def is_workmen
    if has_account
      @user_obj.account.workmen == true
    else
      false
    end
  end

  def is_customer
    if has_account
      @user_obj.account.customer == true
    else
      false
    end
  end

  def can_see(observed_user)
    is_admin || @user_obj == observed_user
  end

  def can_edit(edited_user)
    is_admin || @user_obj == edited_user
  end

  def can_destroy(destroyed_user)
    is_admin || @user_obj == destroyed_user
  end

  def can_update_profile_picture(edited_user)
    is_admin || @user_obj == edited_user
  end

  def can_create_work
    is_admin || is_workmen
  end

  def can_update_works
    is_admin || is_workmen
  end
end