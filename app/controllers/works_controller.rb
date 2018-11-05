class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]

  # GET /works
  # GET /works.json
  def index
    @works = Work.all
    respond_to do |format|
      format.html { render :index }
      format.json { render json: { response: { works: show_like_json(@works) }, status: "OK" } }
    end
  end

  # GET /works/1
  # GET /works/1.json
  def show
    respond_to do |format|
      format.html { render :show }
      format.json { render json: { response: { work: show_like_json(@work) }, status: "OK" } }
    end
  end

  # GET /works/new
  # creation of separate new work
  def new
    @work = Work.new
    respond_to do |format|
      format.html { render :new }
      format.json { render json: { response: { work: show_like_json(@work) }, status: "OK" } }
    end
  end

  # GET /registration_new_work
  # creation of new work and to set a existing works durring user registration
  def registration_new
    @work = Work.new
    @works = Work.all
    respond_to do |format|
      format.html { render :registration_new }
      format.json { render json: { response: { works: show_like_json(@works) }, status: "OK" } }
    end
  end

  # GET /works/1/edit
  # edition of separate work
  def edit
    respond_to do |format|
      format.html { render :edit }
      format.json { render json: { response: { work: show_like_json(@work) }, status: "OK" } }
    end
  end

  # GET /works/1/edit
  # edition of new work and to set a existing works in user profile
  def registration_edit
    @work = Work.new
    @works = Work.all
    @existed_works_id = current_user.work_ids
    respond_to do |format|
      format.html { render :registration_edit }
      format.json { render json: { response: {all_works: show_like_json(@works), existed_work_ids: @existed_works_id}, status: "OK" } }
    end
  end

  # POST /works
  # POST /works.json
  # creation of separate new work
  def create
    @work = Work.new(work_params) 

    respond_to do |format|
      if @work.save
        WorkJob.perform_later(current_user.email) #send email about new work has been created
        format.html { redirect_to root_path, notice: 'Work was successfully created.' }
        format.json { render json: { response: { work: show_like_json(@work) }, status: "Created" } }
      else
        format.html { render :new }
        format.json { render json: { response: { work: show_like_json(@work) }, status: "Unprocessable Entity" } }
      end
    end
  end

  # POST /registration_create_work
  # creation of new work and to set a existing works durring user registration
  def registration_create
    current_user.update_existed_works(params[:existed_works_id])

    if !work_params[:title].empty?  #if there is a new work with params
      @work = Work.new(work_params)
      @work.add_user(current_user)  #calls model method
    end
    
    respond_to do |format|
      if defined? @work
        if @work.save   
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to root_path, notice: 'Work was successfully created.' }
          format.json { render json: { response: { work: show_like_json(@work) }, status: "Created" } }
        else
          format.html { render :new }
          format.json { render json: { response: { work: show_like_json(@work) }, status: "Unprocessable Entity" } }
        end
      else
        format.html { redirect_to root_path, notice: 'Works was successfully setted - new work has not been created.' }
        format.json { render json: { response: "There is no new work.", status: "OK" } }
      end
    end 
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    if policy(@work).can_be_edited_by(current_user)
      respond_to do |format|
        if @work.update(work_params)         
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to @work, notice: 'Work was successfully updated.' }
          format.json { render json: { response: { work: show_like_json(@work) }, status: "OK" } }
        else
          format.html { render :edit }
          format.json { render json: { response: { work: show_like_json(@work) }, status: "Unprocessable Entity" } }
        end
      end
    else
      unauthorized
    end
  end

  # POST /registration_update_work
  # updating of new work and to set a existing works durring user registration
  def registration_update
    current_user.update_existed_works(params[:existed_works_id])
    
    if !work_params[:title].empty?  #if there is a new work with params
      @work = Work.new(work_params)
      @work.add_user(current_user)  #calls model method
    end
    
    respond_to do |format|
      if defined? @work
        if @work.save
          WorkJob.perform_later(current_user.email) #send email about new work has been created
          format.html { redirect_to root_path, notice: 'Work was successfully created.' }
          format.json { render json: { response: { work: show_like_json(@work) }, status: "OK" } }
        else
          format.html { render :new }
          format.json { render json: { response: { work: show_like_json(@work) }, status: "Unprocessable Entity" } }
        end
      else
        format.html { redirect_to root_path, notice: 'Works was successfully setted - new work has not been created.' }
        format.json { render json: { response: "There is no new work.", status: "OK" } }
      end
    end
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    if policy(@work).can_be_destroyed_by(current_user)
      @work.destroy
      respond_to do |format|
        format.html { redirect_to works_url, notice: 'Work was successfully destroyed.' }
        format.json { render json: { response: "Work has been destroyed.", status: "No Content" } }
      end
    else
      unauthorized
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_work
    @work = Work.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def work_params
    params.require(:work).permit(:title, :existed_works_id)
  end

  def show_like_json(works)
      WorkSerializer.new(works).as_json
  end
end
