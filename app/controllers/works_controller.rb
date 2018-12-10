class WorksController < ApplicationController
  before_action :set_work, only: [:show, :update, :destroy, :show_work_users]

  # GET /works
  # GET /works.json
  def index
    @works = Work.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: { works: show_like_json(@works) } }
    end
  end

  # GET /works/1
  # GET /works/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: { work: show_like_json(@work) } }
    end
  end

  # GET /works/new
  # creation of separate new work
  def new
    @work = Work.new
    respond_to do |format|
      format.html { render :new }
      format.json { render json: { work: show_like_json(@work) } }
    end
  end

  # GET /registration_new_work
  # creation of new work and to set a existing works durring user registration
  def registration_new
    if user_signed_in?
      @work = Work.new
      @works = Work.all
      respond_to do |format|
        format.html { render :registration_new }
        format.json { render json: { works: show_like_json(@works) } }
      end
    else
      unauthorized
    end
  end

  # GET /works/:id/edit
  # edition of separate work
  def edit
    if user_signed_in? && policy(Work.find_param(params[:id])).can_be_edited_by(current_user)
      set_work
    
      respond_to do |format|
        format.html { render :edit }
        format.json { render json: { work: show_like_json(@work) } }
      end
    else
      unauthorized
    end
  end

  # GET /works/1/edit
  # edition of new work and to set a existing works in user profile
  def registration_edit
    if user_signed_in?
      @work = Work.new
      @works = Work.all
      @existed_works_id = current_user.work_ids

      respond_to do |format|
        format.html { render :registration_edit }
        format.json { render json: { all_works: show_like_json(@works), existed_work_ids: @existed_works_id } }
      end
    else
      unauthorized
    end
  end

  # POST /works
  # POST /works.json
  # creation of separate new work
  def create
    if user_signed_in? && policy(current_user).can_create_work
      @work = Work.new(work_params)

      respond_to do |format|
        if @work.save
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to root_path, notice: "Work was successfully created." }
          format.json { render status: 201, json: { work: show_like_json(@work), notice: "Work was successfully created."  } }
        else
          format.html { render :new; flash[:notice] = "Work was not created."  }
          format.json { render status: 422, json: { work: show_like_json(@work), notice: "Work was not created." } }
        end
      end
    else
      unauthorized
    end
  end

  # POST /registration_create_work
  # creation of new work and to set a existing works durring user registration
  def registration_create
    if user_signed_in? && policy(current_user).can_create_work
      current_user.update_existed_works(params[:existed_works_id])
  
      if !work_params[:title].empty?  #if there is a new work with params
        @work = Work.new(work_params)
        @work.add_user(current_user)  #calls model method
      end
      
      respond_to do |format|
        if ((defined? @work) && @work.save)
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to root_path, notice: "Works have been set and new work has been created." }
          format.json { render status: 201, json: { work: show_like_json(@work), notice: "Works have been set and new work has been created." } }
        else
          format.html { redirect_to root_path, notice: "Works have been set but new work has not been created." }
          format.json { render status: 201, json: { notice: "Works have been set but new work has not been created." } }
        end
      end  
    else
      unauthorized
    end
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    if user_signed_in? && policy(@work).can_be_edited_by(current_user)
      respond_to do |format|
        if @work.update(work_params)         
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to @work, notice: "Work was successfully updated." }
          format.json { render status: 200, json: { work: show_like_json(@work), notice: "Work was successfully updated." } }
        else
          format.html { render :edit; flash[:notice] = "Work was not updated." }
          format.json { render status: 422, json: { work: show_like_json(@work), notice: "Work was not updated." } }
        end
      end
    else
      unauthorized
    end
  end

  # POST /registration_update_work
  # updating of new work and to set a existing works durring user registration
  def registration_update
    if user_signed_in? && policy(current_user).can_update_works
      current_user.update_existed_works(params[:existed_works_id])
      
      if !work_params[:title].empty?  #if there is a new work with params
        @work = Work.new(work_params)
        @work.add_user(current_user)  #calls model method
      end
      
      respond_to do |format|
        if ((defined? @work) && @work.save)
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to root_path, notice: "Works have been set and new work has been created." }
          format.json { render status: 201, json: { work: show_like_json(@work), notice: "Works have been set and new work has been created." } }
        else
          format.html { redirect_to root_path, notice: "Works have been set but new work has not been created." }
          format.json { render status: 201, json: { notice: "Works have been set but new work has not been created." } }
        end
      end
    else
      unauthorized
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    if user_signed_in? && policy(@work).can_be_destroyed_by(current_user)
      @work.destroy
      respond_to do |format|
        format.html { redirect_to 'work#index', notice: "Work has been destroyed." }
        format.json { render status: 204, json: { notice: "Work has been destroyed." } }
      end
    else
      unauthorized
    end
  end
  
  #GET /works/:id/works
  def show_work_users
    @work_users = @work.work_users

    respond_to do |format|
      format.html { render :show_work_users }
      format.json { render json: { users: UserSerializer.new(@work_users).as_json } }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = Work.find_param(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    params.require(:work).permit(:title, :existed_works_id)
  end

  def show_like_json(works)
      WorkSerializer.new(works).as_json
  end
end
