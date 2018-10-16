class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  # GET /users
  # GET /users.jsonmodel: user
  def index
    @user = User.all
  end

  # GET /users/1
  # GET /users/1.json
  def show
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    #@user.profile_picture.attach(params[:user][:profile_picture])
    #@user.photo.attach(params[:user][:photo])

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'User was successfully created. To continue pleale log in.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'uUser was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      if (session[:admin] == false) #if I'am not admin
        @user = User.find_by(user_name: session[:user_name])
      else #if I'am admin
        if params[:id] #if I'am admin and request have parameter :id      
          @user = User.find(params[:id])
        else #if I'am admin and request don't have parameter :id
           @user = User.find_by(user_name: session[:user_name])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :address, :workmen, :customer, :image_url, :email, :telephone, :user_name, :password, :profile_picture, photos: [])
    end
end
