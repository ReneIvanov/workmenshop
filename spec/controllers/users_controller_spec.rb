require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  def set_user_keys
    return [:id, :username, :email, :address, :telephone, :account, :works]
  end

  def set_user_post_params(created_user)
    @user_params = UserSerializer.new(created_user).as_json.first #Hash
    @user_params.merge!(password: created_user.password)
    @user_post_params = { user: @user_params } #Hash with format needed by UserController
  end

  describe "- GET #index" do
    before(:each) {create_list :user, 5} 
    after(:each) {User.destroy_all}

    context " - admin signed in" do
      before(:each) do
        @admin = create (:user)  #create admin user
        @admin_account = create(:account_admin, user_id: @admin.id)  #create admin account and connect it to @admin    
        sign_in(@admin)  
      end

      context " - HTML format" do
        before(:each) {get :index}

        it_behaves_like "response status 200"  #shared examples located in spec/support/shared_examples/response_status_200.rb
  
        it "- should returns a list of users." do
          expect(assigns(:users)).to eq(User.all)
        end
  
        it "- should render index template." do  
          expect(response).to render_template(:index)
        end
      end

      context " - JSON format" do
        before(:each) {get :index, format: :json}

        it_behaves_like "response status 200"  #shared examples located in spec/support/shared_examples/response_status_200.rb
        
        it "- should returns a list of users." do
          user_keys = set_user_keys
          
          responsed_body = JSON.parse(response.body).deep_symbolize_keys #separate from response the body and convert in into Hash
          expect(responsed_body[:users].count).to eq(6)
          expect(responsed_body.keys).to eq([:users])
          expect(responsed_body[:users].first.keys).to eq(user_keys) #responsed_body == Hash, responsed_body[:users] == Array of users, responsed_body[:users].first == first user(Hash), responsed_body[:users].first.keys == first user(Hash) keys 
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) {get :index}

        it_behaves_like "unauthorized redirection examples"  #shared examples located in spec/support/shared_examples/unauthorized_redirection_example.rb
  
        it "- shouldn't returns a list of users." do
          expect(assigns(:users)).to eq(nil)
        end
      end

      context " - JSON format" do
        before(:each) {get :index, format: :json}

        it_behaves_like "unauthorized JSON status" #shared examples located in spec/support/shared_examples/unauthorized_JSON_status.rb

        it "- shouldn't returns a list of users." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys #separate from response the body and convert in into Hash
          expect(responsed_body[:notice]).to eq("You have not rights for this action - please sign in with necessary rights.")
          expect(responsed_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe "- GET #show" do
    before(:each) {@showed_user = create :user} 
    after(:each) {User.destroy_all}

    context " - admin signed in" do
      before(:each) do
        @admin = create (:user) 
        @admin_account = create(:account_admin, user_id: @admin.id)
        sign_in(@admin)  
      end

      context " - HTML format" do
        before(:each) { get :show, params: { id: @showed_user.id } }

        it_behaves_like "response status 200"
  
        it "- should returns a user." do
          expect(assigns(:user)).to eql(User.find(@showed_user.id))
        end
  
        it "- should render show template." do  
          expect(response).to render_template(:show)
        end
      end

      context " - JSON format" do
        before(:each) {get :show, params: { id: @showed_user.id }, format: :json}

        it_behaves_like "response status 200"

        it "- should returns a user." do
          user_keys = set_user_keys
          
          responsed_body = JSON.parse(response.body).deep_symbolize_keys
          expect(responsed_body[:user].count).to eq(1)
          expect(responsed_body.keys).to eq([:user])
          expect(responsed_body[:user].first.keys).to eq(user_keys) 
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :show, params: { id: @showed_user.id } }

        it_behaves_like "unauthorized redirection examples"  
  
        it "- shouldn't returns a user." do
          expect(assigns(:user)).to eq(nil)
        end
      end

      context " - JSON format" do
        before(:each) {get :show, params: { id: @showed_user.id }, format: :json}

        it_behaves_like "unauthorized JSON status" 

        it "- shouldn't returns a user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys
          expect(responsed_body[:notice]).to eq("You have not rights for this action - please sign in with necessary rights.")
          expect(responsed_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe "- GET #new" do 
    context " - HTML format" do
      before(:each) { get :new }
      
      it_behaves_like "response status 200"

      it "- should returns a new user." do
        expect(assigns(:user).id).to eq(nil)
      end

      it "- should render new template." do  
        expect(response).to render_template(:new)
      end
    end

    context " - JSON format" do
      before(:each) {get :new, format: :json}

      it_behaves_like "response status 200"

      it "- should returns a new user." do
        user_keys = set_user_keys
        
        responsed_body = JSON.parse(response.body).deep_symbolize_keys
        expect(responsed_body[:user].count).to eq(1)
        expect(responsed_body.keys).to eq([:user])
        expect(responsed_body[:user].first.keys).to eq(user_keys) 
      end
    end
  end

  describe "- GET #edit" do
    before(:each) {@edited_user = create :user} 
    after(:each) {User.destroy_all}

    context " - admin signed in" do
      before(:each) do
        @admin = create (:user) 
        @admin_account = create(:account_admin, user_id: @admin.id)
        sign_in(@admin)  
      end

      context " - HTML format" do
        before(:each) { get :edit, params: { id: @edited_user.id } }

        it_behaves_like "response status 200"
  
        it "- should returns a user." do
          expect(assigns(:user)).to eql(User.find(@edited_user.id))
        end
  
        it "- should render edit template." do  
          expect(response).to render_template(:edit)
        end
      end

      context " - JSON format" do
        before(:each) {get :edit, params: { id: @edited_user.id }, format: :json}

        it_behaves_like "response status 200"

        it "- should returns a user." do
          user_keys = set_user_keys
          
          responsed_body = JSON.parse(response.body).deep_symbolize_keys
          expect(responsed_body[:user].count).to eq(1)
          expect(responsed_body.keys).to eq([:user])
          expect(responsed_body[:user].first.keys).to eq(user_keys) 
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :edit, params: { id: @edited_user.id } }

        it_behaves_like "unauthorized redirection examples"  
  
        it "- shouldn't returns a user." do
          expect(assigns(:user)).to eq(nil)
        end
      end

      context " - JSON format" do
        before(:each) {get :edit, params: { id: @edited_user.id }, format: :json}

        it_behaves_like "unauthorized JSON status" 

        it "- shouldn't returns a user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys
          expect(responsed_body[:notice]).to eq("You have not rights for this action - please sign in with necessary rights.")
          expect(responsed_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe " - POST #create" do 
    before(:each) {@created_user = build :user}
    after(:each) {User.destroy_all}

    context " - user is saved into database" do
      context " - HTML format" do
        before(:each) { post :create, params: set_user_post_params(@created_user) }
  
        it "- should returns a redirectiom(:found) response status." do
          expect(response).to have_http_status(302)
        end
  
        it " - should returns a new created user." do
          @returned_user = assigns(:user)
          @created_user.id = @returned_user.id
          expect(@returned_user).to eq(@created_user)
        end
  
        it " - created user should be saved into database" do
          @created_user.id = assigns(:user).id
          @saved_user = User.find(assigns(:user).id)
          expect(@saved_user).to eq(@created_user)
        end
  
        it " - should redirect to root." do  
          expect(response).to redirect_to(:root)
        end
      end
  
      context " - JSON format" do
        before(:each) { post :create, format: :json, params: set_user_post_params(@created_user) }
  
        it "- should returns a :created response status." do
          expect(response).to have_http_status(201)
        end
  
        it " - should returns a new created user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
          responsed_user = responsed_body[:user] #Array
          serialized_created_user = UserSerializer.new(@created_user).as_json #Array
          serialized_created_user.first[:id] = responsed_user.first[:id]
  
          expect(responsed_body[:user].count).to eq(1)
          expect(responsed_body.keys).to eq([:user]) 
          expect(responsed_user). to eq(serialized_created_user)
        end
      end
    end

    context " - user isn't saved into database" do
      before(:each) {@created_user.email = ""} #this is reason why user will not be saved into database

      context " - HTML format" do
        before(:each) do
          post :create, params: set_user_post_params(@created_user)
        end
         
        it_behaves_like "response status 200"

        it "- should render new template." do 
          expect(response).to render_template(:new)
        end
        
        it " - should return unsaved user" do
          @created_user.id = 1  #because we need to compare with assigns(:user) and for this is necessary to have some id
          assigns(:user).id = 1
          expect(assigns(:user)).to eq(@created_user)
        end
      end

      context " - JSON format" do
        before(:each) { post :create, format: :json, params: set_user_post_params(@created_user) }
  
        it "- should returns a :unprocessable_entity response status." do
          expect(response).to have_http_status(422)
        end
  
        it " - should returns a uncreated user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
          responsed_user = responsed_body[:user] #Array
          serialized_created_user = UserSerializer.new(@created_user).as_json #Array
  
          expect(responsed_body[:user].count).to eq(1)
          expect(responsed_body.keys).to eq([:user]) 
          expect(responsed_user). to eq(serialized_created_user)
        end
      end
    end 
  end

  describe " - PUT #update" do 
    before(:each) do
      @created_user = create :user #save some uset into database
      @loaded_user = User.find(@created_user.id) #load user from database
      @modified_user = build :user
      @modified_user.id = @loaded_user.id #this user is modified user with same id like user in database
    end
    after(:each) {User.destroy_all}

    context " - admin signed in" do
      before(:each) do
        @admin = create (:user) 
        @admin_account = create(:account_admin, user_id: @admin.id)
        sign_in(@admin)  
      end

      context " - modified user is updated in database" do
        context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_user.id, user: set_user_post_params(@modified_user)[:user] } } #update need to have :id in :params
    
          it "- should returns a redirection(:found) response status." do
            expect(response).to have_http_status(302)
          end
    
          it " - should returns a updated user." do
            @returned_user = assigns(:user)
            expect(@returned_user).to eq(@modified_user)
          end
    
          it " - user should be updated in database" do
            @updated_user = User.find(@modified_user.id)
            expect(@updated_user).to eq(@modified_user)
          end
    
          it " - should redirect to root." do  
            expect(response).to redirect_to("/users/#{@loaded_user.id}")
          end
        end
    
        #context " - JSON format" do
        #  before(:each) { post :create, format: :json, params: set_user_post_params(@created_user) }
    #
        #  it "- should returns a :created response status." do
        #    expect(response).to have_http_status(201)
        #  end
    #
        #  it " - should returns a new created user." do
        #    responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
        #    responsed_user = responsed_body[:user] #Array
        #    serialized_created_user = UserSerializer.new(@created_user).as_json #Array
        #    serialized_created_user.first[:id] = responsed_user.first[:id]
    #
        #    expect(responsed_body[:user].count).to eq(1)
        #    expect(responsed_body.keys).to eq([:user]) 
        #    expect(responsed_user). to eq(serialized_created_user)
        #  end
        #end
      end

      #context " - user isn't saved into database" do
      #  before(:each) {@created_user.email = ""} #this is reason why user will not be saved into database
  #
      #  context " - HTML format" do
      #    before(:each) do
      #      post :create, params: set_user_post_params(@created_user)
      #    end
      #     
      #    it_behaves_like "response status 200"
  #
      #    it "- should render new template." do 
      #      expect(response).to render_template(:new)
      #    end
      #    
      #    it " - should return unsaved user" do
      #      @created_user.id = 1  #because we need to compare with assigns(:user) and for this is necessary to have some id
      #      assigns(:user).id = 1
      #      expect(assigns(:user)).to eq(@created_user)
      #    end
      #  end
  #
      #  context " - JSON format" do
      #    before(:each) { post :create, format: :json, params: set_user_post_params(@created_user) }
    #
      #    it "- should returns a :unprocessable_entity response status." do
      #      expect(response).to have_http_status(422)
      #    end
    #
      #    it " - should returns a uncreated user." do
      #      responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
      #      responsed_user = responsed_body[:user] #Array
      #      serialized_created_user = UserSerializer.new(@created_user).as_json #Array
    #
      #      expect(responsed_body[:user].count).to eq(1)
      #      expect(responsed_body.keys).to eq([:user]) 
      #      expect(responsed_user). to eq(serialized_created_user)
      #    end
      #  end
      #end 
    end
  end
#
#    context "with invalid params" do
#      xit "returns a success response (i.e. to display the 'edit' template)" do
#        person = Person.create! valid_attributes
#        put :update, params: {id: person.to_param, person: invalid_attributes}, session: valid_session
#        expect(response).to be_successful
#      end
#    end
#  end
#
#  describe "DELETE #destroy" do
#    xit "destroys the requested person" do
#      person = Person.create! valid_attributes
#      expect {
#        delete :destroy, params: {id: person.to_param}, session: valid_session
#      }.to change(Person, :count).by(-1)
#    end
#
#    xit "redirects to the users list" do
#      person = Person.create! valid_attributes
#      delete :destroy, params: {id: person.to_param}, session: valid_session
#      expect(response).to redirect_to(users_url)
#    end
#  end
end
