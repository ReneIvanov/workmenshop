class WorkPolicy < ApplicationPolicy
  def initialize(work_obj)
    @work_obj = work_obj
  end

  def can_be_edited_by(user_obj)
    policy(user_obj).is_admin
  end

  def can_be_destroyed_by(user_obj)
    policy(user_obj).is_admin
  end
end