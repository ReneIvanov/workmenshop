class ApplicationPolicy
  def policy(object)
    @object_string = object.class.name      #string = name of object class
    @object_policy_string = @object_string << "Policy"  #string = name of policy class 
    @object_policy_const = Object.const_get(@object_policy_string)  #constance of policy class

    @object_policy = @object_policy_const.new(object) #return policy object (e.g. if claas of object in argument is "User", this action returm object of UserPolicy)
  end
end
