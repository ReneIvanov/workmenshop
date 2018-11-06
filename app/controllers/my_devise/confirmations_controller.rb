class MyDevise::ConfirmationsController < Devise::ConfirmationsController
	
  protected
	
  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    is_navigational_format? ? new_session_path(resource_name) : '/'
  end

  # The path used after confirmation.
  def after_confirmation_path_for(resource_name, resource)
    if user_signed_in?
      signed_in_root_path(resource)
    else
      new_session_path(resource_name)
    end
  end
end
