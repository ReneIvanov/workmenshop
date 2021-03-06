class UsersController < ApplicationController
  # GET /users
  # GET /users.jsonmodel: user
  def index
    if user_signed_in? && policy(current_user).is_admin
      @users = User.all
      respond_to do |format|
        format.html { render :index }
        format.json { render json: { users: show_like_json(@users) } }
      end
    else
      unauthorized
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if user_signed_in? && policy(current_user).can_see(User.find_param(params[:id]))
      set_user 
      respond_to do |format|
        format.html { render :show }
        format.json { render json: { user: show_like_json(@user) } }
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
      format.json { render json: { user: show_like_json(@user) } }
    end   
  end

  # GET /users/:id/edit
  def edit
    if user_signed_in? && policy(current_user).can_edit(User.find_param(params[:id]))
      set_user
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { user: show_like_json(@user) } }
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
        format.html { redirect_to root_path, notice: "User was successfully created." }
        format.json { render status: 201, json: { user: show_like_json(@user), notice: "User was successfully created." } }
      else
        format.html { render :new; flash[:notice] = "User was not created." }
        format.json { render status: 422, json: { user: show_like_json(@user), notice: "User was not created." } }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    binding.pry
    if user_signed_in? && policy(current_user).can_edit(User.find_param(params[:id]))
      set_user
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: "User was successfully updated." }
          format.json { render json: { user: show_like_json(@user), notice: "User was successfully updated." } }
        else
          format.html { render :edit; flash[:notice] = "User was not updated." }
          format.json { render status: 422, json: { user: show_like_json(@user), notice: "User was not updated." } }
        end
      end
    else
      unauthorized
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    if user_signed_in? && policy(current_user).can_destroy(User.find_param(params[:id]))
      set_user
      @user.destroy
      respond_to do |format|
        format.html { redirect_to root_path, notice: "User has been destroyed." }
        format.json { render status: 204, json: { notice: "User has been destroyed." } }
      end
    else
      unauthorized
    end
  end
  
  # GET /users/:id/pictures
  def pictures_show
    set_user
    respond_to do |format|
      format.html { render :pictures}
      format.json { render json: { user: show_like_json(@user) } }
    end
  end
  
  # PATCH /users/:id/pictures
  def pictures_update
    if user_signed_in? && policy(current_user).can_update_profile_picture(User.find_param(params[:id])) 
      set_user
      if params[:user] != nil && params[:user][:profile_picture] != nil
        @user.profile_picture.attach(params[:user][:profile_picture])
  
        respond_to do |format|
          format.html { render :pictures; flash[:notice] = "Profile picture has been changed." }
          format.json { render json: { user: show_like_json(@user), notice: "Profile picture has been changed." } }
        end
      else
        respond_to do |format|
          format.html { render :pictures; flash[:notice] = "Profile picture NOT changed!" }
          format.json { render status: 422, json: { user: show_like_json(@user), notice: "Profile picture NOT changed!" } }
        end
      end
    else
      unauthorized
    end
  end
  
  #GET /users/:id/works
  def show_user_works
    set_user
    @user_works = @user.user_works

    respond_to do |format|
      format.html { render :show_user_works }
      format.json { render json: { works: WorkSerializer.new(@user_works).as_json } }
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:username, :address, :email, :telephone, :password, :profile_picture, photos: [])
  end

  def set_user
    @user = User.find_param(params[:id])
  end

  def show_like_json(users)
      UserSerializer.new(users).as_json
  end
end
