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
    if user_signed_in? && policy(Account.find(params[:id])).can_be_seen_by(current_user)
      @account = set_account
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { response: { account: show_like_json(@account) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end

  # GET /accounts/new
  def new
    if user_signed_in?
      @account = Account.new
      respond_to do |format|
        format.html { render :new }
        format.json { render json: { response: { account: show_like_json(@account) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end

  # GET /accounts/1/edit
  def edit
    if user_signed_in? && policy(Account.find(params[:id])).can_be_seen_by(current_user)
      @account = set_account
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { response: { account: show_like_json(@account) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end

  # POST /accounts
  # POST /accounts.json
  def create
    @current_account = current_user.account if current_user.account

    if user_signed_in? 
      @account = Account.new(account_params)
      @account.user_id = current_user.id    
      respond_to do |format|
        if @account.save
          @current_account.delete if @current_account
          if @account.workmen?
            format.html { redirect_to registration_new_work_path, notice: 'Please continue with specifing your services.' }
          else
            format.html { redirect_to root_path, notice: 'Your account has been succefully created.' }
          end
          format.json { render json: { response: { account: show_like_json(@account) }, status: "Created" } }
        else
          format.html { render :new }
          format.json { render json: { response: { account: show_like_json(@account) }, status: "Unprocessable Entity" } }
        end
      end
    else
      unauthorized
    end
  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    if user_signed_in? && policy(Account.find(params[:id])).can_be_seen_by(current_user)
      @account = set_account    
      respond_to do |format|
        if @account.update(account_params)
          format.html { redirect_to registration_edit_work_path, notice: 'Please continue.' }
          format.json { render json: { response: { account: show_like_json(@account) }, status: "OK" } }
        else
          format.html { render :edit }
          format.json { render json: { response: {account: show_like_json(@account) }, status: "Unprocessable Entity" } }
        end
      end
    else
      unauthorized
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    if user_signed_in? && policy(Account.find(params[:id])).can_be_seen_by(current_user)
      @account = set_account
      @account.destroy
      respond_to do |format|
        format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
        format.json { render json: { response: "Account has been destroyed.", status: "No Content" } }
      end
    else
      unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_account
    @account = Account.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def account_params
    params.require(:account).permit(:workmen, :customer)
  end

  def show_like_json(accounts)
      AccountSerializer.new(accounts).as_json
  end
end
