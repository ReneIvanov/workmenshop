class PeopleController < ApplicationController
  before_action :set_person, only: [:show, :edit, :update, :destroy]
   
  skip_before_action :authorize_admin, only: [:show, :new, :edit, :create, :update, :destroy, :look]
  skip_before_action :authorize_user
  # GET /people
  # GET /people.jsonmodel: person
  def index
    @people = Person.all
  end

  # GET /people/1
  # GET /people/1.json
  def show
  end

  # GET /people/new
  def new
    @person = Person.new
  end

  # GET /people/1/edit
  def edit
  end

  # POST /people
  # POST /people.json
  def create
    @person = Person.new(person_params)
    #@person.profile_picture.attach(params[:person][:profile_picture])
    #@person.photo.attach(params[:person][:photo])

    respond_to do |format|
      if @person.save
        format.html { redirect_to root_path, notice: 'Person was successfully created. To continue pleale log in.' }
        format.json { render :show, status: :created, location: @person }
      else
        format.html { render :new }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /people/1
  # PATCH/PUT /people/1.json
  def update

    respond_to do |format|
      if @person.update(person_params)
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { render :show, status: :ok, location: @person }
      else
        format.html { render :edit }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person.destroy
    respond_to do |format|
      format.html { redirect_to people_url, notice: 'Person was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_person
      if (session[:admin] == false) #if I'am not admin
        @person = Person.find(session[:person_id])
      else #if I'am admin
        if params[:id] #if I'am admin and request have parameter :id      
          @person = Person.find(params[:id])
        else #if I'am admin and request don't have parameter :id
           @person = Person.find(session[:person_id])
        end
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def person_params
      params.require(:person).permit(:name, :address, :workmen, :customer, :image_url, :email, :telephone, :user_name, :password, :profile_picture, photos: [])
    end
end
