class MyDevise::RegistrationsController < Devise::RegistrationsController
  
  protected
  
  # The path used after sign up. You need to overwrite this method
  # in your own RegistrationsController.
  def after_sign_up_path_for(resource)
    accounts_registration_new_path
  end

  # The path used after sign up for inactive accounts. You need to overwrite
  # this method in your own RegistrationsController.
  def after_inactive_sign_up_path_for(resource)
    root_path
  end

  # The default url to be used after updating a resource. You need to overwrite
  # this method in your own RegistrationsController.
  def after_update_path_for(resource)
    if current_user.account
      accounts_registration_edit_path(current_user.account)
    else
      accounts_registration_new_path
    end
  end
end
