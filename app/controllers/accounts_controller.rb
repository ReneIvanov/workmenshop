class AccountsController < ApplicationController
  # GET /accounts
  # GET /accounts.json
  def index
    #if user_signed_in? && policy(current_user).is_admin
      @accounts = Account.all
      respond_to do |format|
        format.html { render :index }
        format.json { render json: { accounts: show_like_json(@accounts) } }
      end
    #else
    #  unauthorized
    #end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if user_signed_in? && policy(Account.find_param(params[:id])).can_be_seen_by(current_user)
      @account = set_account
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { account: show_like_json(@account) } }
      end
    else
      unauthorized
    end
  end

  # GET /accounts/new
  def registration_new
    @account = Account.new
    respond_to do |format|
      format.html { render :new }
      format.json { render json: { account: show_like_json(@account) } }
    end
  end

  # GET /accounts/1/edit
  def registration_edit
    if user_signed_in? && policy(Account.find_param(params[:id])).can_be_seen_by(current_user)
      @account = set_account
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { account: show_like_json(@account) } }
      end
    else
      unauthorized
    end
  end

  # POST /accounts
  # POST /accounts.json
  def registration_create
    if user_signed_in? 
      @current_account = current_user.account if current_user.account
      @account = Account.new(account_params)
      @account.user = current_user   
      
      respond_to do |format|
        if @account.save
          @current_account.delete if @current_account
          if (user_signed_in? && policy(current_user).can_create_work)
            format.html { redirect_to registration_new_work_path, notice: "Please continue with specifing your services." }
          else
            format.html { redirect_to root_path, notice: "Your account was succefully created." }
          end
          format.json { render status: 201, json: { account: show_like_json(@account), notice: "Your account was succefully created." } }
        else
          format.html { render :new; flash[:notice] = "Account was not created." }
          format.json { render status: 422, json: { account: show_like_json(@account), notice: "Account was not created." } }
        end
      end
    else
      unauthorized
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def registration_update
    if user_signed_in? && policy(Account.find_param(params[:id])).can_be_seen_by(current_user)
      @account = set_account    
      respond_to do |format|
        if (@account.update(account_params))
          current_user.reload
          if (user_signed_in? && policy(current_user).can_update_works)
            format.html { redirect_to registration_edit_work_path, notice: "Account was successfully updated." }
          else
            format.html { redirect_to root_path, notice: "Your account was succefully updated." }
          end
          format.json { render status: 200, json: { account: show_like_json(@account), notice: "Account was successfully updated." } }
        else
          format.html { render :edit; flash[:notice] = "Account was not updated." }
          format.json { render status: 422, json: { account: show_like_json(@account), notice: "Account was not updated." } }
        end
      end
    else
      unauthorized
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    if user_signed_in? && policy(Account.find_param(params[:id])).can_be_seen_by(current_user)
      @account = set_account
      @account.destroy
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Account was destroyed.' }
        format.json { render status: 204, json: {notice: "Account was destroyed." } }
      end
    else
      unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find_param(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:workmen, :customer, :admin)
  end

  def show_like_json(accounts)
      AccountSerializer.new(accounts).as_json
  end
end
