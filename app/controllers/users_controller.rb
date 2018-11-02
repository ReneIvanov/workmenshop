class UsersController < ApplicationController
  # GET /users
  # GET /users.jsonmodel: user
  def index
    if user_signed_in? && policy(current_user).is_admin
      @users = User.all
      respond_to do |format|
        format.html {render :index}
        format.json {render json: show_like_json(@users)}
      end
    else
      redirect_to new_user_session_path , notice: 'You have not rights for this action - please sign in with necessary rights.'
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    if user_signed_in? && policy(current_user).can_see(User.find(params[:id]))
      set_user 
      respond_to do |format|
        format.html {render :show}
        format.json {render json:  show_like_json}
      end
    else
      redirect_to new_user_session_path , notice: 'You have not rights for this action - please sign in with necessary rights.'
    end
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    
    if user_signed_in? && policy(current_user).can_edit(User.find(params[:id]))
      set_user
    else
      redirect_to new_user_session_path , notice: 'You have not rights for this action - please sign in with necessary rights.'
    end
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
    if user_signed_in? && policy(current_user).can_edit(User.find(params[:id]))
      set_user
      respond_to do |format|
        if @user.update(user_params)
          format.html { redirect_to @user, notice: 'uUser was successfully updated.' }
          format.json { render :show, status: :ok, location: @user }
        else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    else
      redirect_to new_user_session_path , notice: 'You have not rights for this action - please sign in with necessary rights.'
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
        format.json { head :no_content }
      end
    else
      redirect_to new_user_session_path , notice: 'You have not rights for this action - please sign in with necessary rights.'
    end
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit(:name, :address, :workmen, :customer, :image_url, :email, :telephone, :user_name, :password, :profile_picture, photos: [])
  end

  def set_user
    @user = User.find(params[:id])
  end

  def show_like_json(users)
      UserSerializer.new(users).as_json
  end
end
