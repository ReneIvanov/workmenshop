class UsersController < ApplicationController
  # GET /users
  # GET /users.jsonmodel: user
  def index
    if user_signed_in? && policy(current_user).is_admin
      @users = User.all
      respond_to do |format|
        format.html { render :index }
        format.json { render json: { response: { users: show_like_json(@users) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if user_signed_in? && policy(current_user).can_see(User.find(params[:id]))
      set_user 
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { response: { user: show_like_json(@user) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end

  # GET /users/new
  def new
    @user = User.new
    respond_to do |format|
      format.html { render :new }
      format.json { render json: { response: { user: show_like_json(@user) }, status: "OK" } }
    end   
  end

  # GET /users/1/edit
  def edit
    if user_signed_in? && policy(current_user).can_edit(User.find(params[:id]))
      set_user
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { response: { user: show_like_json(@user) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end

  # POST /users
  # POST /users.json
  def create 
    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path, notice: 'User was successfully created. To continue pleale log in.' }
        format.json { render json: { response: { user: show_like_json(@user) }, status: "Created" } }
      else
        format.html { render :new, notice: 'User was not created. Please try again.' }
        format.json { render json: { response: {user: show_like_json(@user) }, status: "Unprocessable Entity" } }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    if user_signed_in? && policy(current_user).can_edit(User.find(params[:id]))
      set_user
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'User was successfully updated.' }
          format.json { render json: { response: { user: show_like_json(@user) }, status: "OK" } }
        else
          format.html { render :edit }
          format.json { render json: { response: { user: show_like_json(@user) }, status: "Unprocessable Entity" } }
        end
      end
    else
      unauthorized
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if policy(current_user).can_destroy(User.find(params[:id]))
      set_user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
        format.json { render json: { response: "User has been destroyed.", status: "No Content" } }
      end
    else
      unauthorized
    end
  end
  
  # GET /users_pictures
  def pictures_show
    if user_signed_in?
      @user = current_user
      respond_to do |format|
        format.html { render :pictures}
        format.json { render json: { response: { user: show_like_json(@user) }, status: "OK" } }
      end
    else
      unauthorized
    end
  end
  
  # PATCH /users/picture
  def pictures_update
    @user = current_user
    
    if params[:user] != nil && params[:user][:profile_picture] != nil
      @user.profile_picture.attach(params[:user][:profile_picture])
      flash[:notice] = 'Profile picture has been changed.'

      respond_to do |format|
        format.html { render :pictures }
        format.json { render json: { response: { user: show_like_json(@user) }, status: "OK" } }
      end
    else
      flash[:notice] = 'Profile picture NOT changed!'
      respond_to do |format|
        format.html { render :pictures }
        format.json { render json: { response: { user: show_like_json(@user) }, status: "Unprocessable Entity" } }
      end
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :address, :email, :telephone, :password, :profile_picture, photos: [])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def show_like_json(users)
      UserSerializer.new(users).as_json
  end
end
