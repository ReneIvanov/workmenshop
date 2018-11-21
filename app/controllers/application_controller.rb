class ApplicationController < ActionController::Base
  before_action :basic_rights
  before_action :configure_permitted_parameters, if: :devise_controller?  #because we want to add parameters to user = devise
  
  protected
      
  def configure_permitted_parameters #descripted on https://github.com/plataformatec/devise
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username, :address, :telephone]) #allows parameters for sign_up action (keys in devise.rb are permited by default)
    devise_parameter_sanitizer.permit(:sign_in, keys: [:username, :address, :telephone]) #allows parameters for sign_in action (keys in devise.rb are permited by default)
    devise_parameter_sanitizer.permit(:account_update, keys: [:username, :address, :telephone]) #allows parameters for account_update action (keys in devise.rb are permited by default)
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def policy(object)
    ApplicationPolicy.new.policy(object)
  end

  def basic_rights	#set some basic informations for views about user rights in order to display some kind of data. 
    if user_signed_in?	#if is current_user sign in
      @is_admin = policy(current_user).is_admin
      @is_workmen = policy(current_user).is_workmen
      @is_customer = policy(current_user).is_customer
      @is_account = current_user.account.is_a? Account #has current user account?
    end
  end

  def unauthorized  #response if user is not authorized fo current action
    respond_to do |format|
      format.html { redirect_to new_user_session_path, status: 302, notice: "You have not rights for this action - please sign in with necessary rights." }
      format.json { render status: 401, json: { notice: "You have not rights for this action - please sign in with necessary rights." } }
    end
  end
end
