require 'rails_helper'

RSpec.describe UsersController, type: :controller do

  def set_user_keys
    return [:id, :username, :email, :address, :telephone, :account, :works]
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
        before(:each) {get :index, :format => :json}

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
        before(:each) {get :show, params: { id: @showed_user.id }, :format => :json}

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
      before(:each) {get :new, :format => :json}

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

#  describe "POST #create" do
#    context "with valid params" do
#      xit "creates a new Person" do
#        expect {
#          post :create, params: {person: valid_attributes}, session: valid_session
#        }.to change(Person, :count).by(1)
#      end
#
#      xit "redirects to the created person" do
#        post :create, params: {person: valid_attributes}, session: valid_session
#        expect(response).to redirect_to(Person.last)
#      end
#
#      #TOMI start
#      it 'should be successful' do
#        expect(response.status).to eq(200)
#      end
#      #TOMI END
#    end
#
#    context "with invalid params" do
#      xit "returns a success response (i.e. to display the 'new' template)" do
#        post :create, params: {person: invalid_attributes}, session: valid_session
#        expect(response).to be_successful
#      end
#    end
#  end
#
#  describe "PUT #update" do
#    context "with valid params" do
#      let(:new_attributes) {
#        skip("Add a hash of attributes valid for your model")
#      }
#
#      xit "updates the requested person" do
#        person = Person.create! valid_attributes
#        put :update, params: {id: person.to_param, person: new_attributes}, session: valid_session
#        person.reload
#        skip("Add assertions for updated state")
#      end
#
#      xit "redirects to the person" do
#        person = Person.create! valid_attributes
#        put :update, params: {id: person.to_param, person: valid_attributes}, session: valid_session
#        expect(response).to redirect_to(person)
#      end
#    end
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
