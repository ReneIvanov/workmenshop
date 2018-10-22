class WorksController < ApplicationController
  before_action :set_work, only: [:show, :edit, :update, :destroy]
  
  # GET /works
  # GET /works.json
  def index
    @works = Work.all
  end

  # GET /works/1
  # GET /works/1.json
  def show
  end

  # GET /works/new
  # creation of separate new work
  def new
    @work = Work.new
  end

  # GET /registration_new_work
  # creation of new work and to set a existing works durring user registration
  def registration_new
    @work = Work.new
    @works = Work.all
  end

  # GET /works/1/edit
  # edition of separate work
  def edit
  end

  # GET /works/1/edit
  # edition of new work and to set a existing works in user profile
  def registration_edit
    @work = Work.new
    @works = Work.all
    @existed_works_id = current_user.work_ids
  end

  # POST /works
  # POST /works.json
  # creation of separate new work
  def create
    @work = Work.new(work_params) 

    respond_to do |format|
      if @work.save
        format.html { redirect_to root_path, notice: 'Work was successfully created.' }
        format.json { render :show, status: :created, location: @work }
      else
        format.html { render :new }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
    end
  end

  # POST /registration_create_work
  # creation of new work and to set a existing works durring user registration
  def registration_create
    current_user.update_existed_works(params[:existed_works_id])
    #if params[:existed_works_id] #if there are a existed works params
    #  @existed_works_id = params[:existed_works_id].map(&:to_i) #save existed workd id like array of integers
    #  @existed_works = Work.find(@existed_works_id) #find all works according array of id
    #  @existed_works.each do |w|
    #    current_user.add_work w #call model method
    #  end
    #end
    if !work_params[:title].empty?  #if there is a new work with params
      @work = Work.new(work_params)
      @work.add_user(current_user)  #calls model method
    end
    
    respond_to do |format|
      if defined? @work
        if @work.save
          format.html { redirect_to root_path, notice: 'Work was successfully created.' }
          format.json { render :show, status: :created, location: @work }
        else
          format.html { render :new }
          format.json { render json: @work.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, notice: 'Work was successfully created.' }
      end
    end 
  end

  # PATCH/PUT /works/1
  # PATCH/PUT /works/1.json
  def update
    respond_to do |format|
      if @work.update(work_params)
        format.html { redirect_to @work, notice: 'Work was successfully updated.' }
        format.json { render :show, status: :ok, location: @work }
      else
        format.html { render :edit }
        format.json { render json: @work.errors, status: :unprocessable_entity }
      end
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
          format.html { redirect_to root_path, notice: 'Work was successfully created.' }
          format.json { render :show, status: :created, location: @work }
        else
          format.html { render :new }
          format.json { render json: @work.errors, status: :unprocessable_entity }
        end
      else
        format.html { redirect_to root_path, notice: 'Work was successfully created.' }
      end
    end 
  end

  # DELETE /works/1
  # DELETE /works/1.json
  def destroy
    @work.destroy
    respond_to do |format|
      format.html { redirect_to works_url, notice: 'Work was successfully destroyed.' }
      format.json { head :no_content }
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
end