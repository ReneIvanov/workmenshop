class AccountsController < ApplicationController
  before_action :set_account, only: [:show, :edit, :update, :destroy]

  # GET /accounts
  # GET /accounts.json
  def index
    if user_signed_in? && policy(current_user).is_admin
      @accounts = Account.all
    else
      redirect_to new_user_session_path, notice: 'You have not rights for this action - please sign in with necessary rights.'
    end
  end

  # GET /accounts/1
  # GET /accounts/1.json
  def show
    if user_signed_in? && policy(Account.find(params[:id])).can_be_seen_by(current_user)
      @account = set_account
    else
      redirect_to new_user_session_path, notice: 'You have not rights for this action - please sign in with necessary rights.'
    end
  end

  # GET /accounts/new
  def new
    @account = Account.new
  end

  # GET /accounts/1/edit
  def edit
  end

  # POST /accounts
  # POST /accounts.json
  def create
    if current_user.account
      current_user.account.delete
    end  
      @account = Account.new(account_params)
      @account.user_id = current_user.id    
    
      respond_to do |format|
        if @account.save
          if @account.workmen?
            format.html { redirect_to registration_new_work_path, notice: 'Please continue with specifing your services.' }
          else
            format.html { redirect_to root_path, notice: 'Your account has been succefully created.' }
          end
          format.json { render :show, status: :created, location: @account }
        else
          format.html { render :new }
          format.json { render json: @account.errors, status: :unprocessable_entity }
        end
      end

  end

  # PATCH/PUT /accounts/1
  # PATCH/PUT /accounts/1.json
  def update
    respond_to do |format|
      if @account.update(account_params)
        format.html { redirect_to registration_edit_work_path, notice: 'Please continue.' }
        format.json { render :show, status: :ok, location: @account }
      else
        format.html { render :edit }
        format.json { render json: @account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /accounts/1
  # DELETE /accounts/1.json
  def destroy
    @account.destroy
    respond_to do |format|
      format.html { redirect_to accounts_url, notice: 'Account was successfully destroyed.' }
      format.json { head :no_content }
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
end
