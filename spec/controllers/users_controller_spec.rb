require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  def set_user_keys
    return [:id, :username, :email, :address, :telephone, :account, :works, :profile_picture]
  end

  def request_user_params(created_user)
    @user_params = serialize(created_user)
    @user_params.merge!(password: created_user.password)
    @user_post_params = { user: @user_params } #Hash with format needed by UserController
  end

  def serialize(object)
    SerializersTestHelper.serialize(object)
  end

  def sign_in_admin
    @admin = create (:user) 
    @admin_account = create(:account_admin, user_id: @admin.id)
    sign_in(@admin)
  end

  def parser(content)
    JSON.parse(content).deep_symbolize_keys
  end
  
  describe "- GET #index" do
    before(:each) {create_list :user, 5}

    context " - admin signed in" do
      before(:each) {sign_in_admin}

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
          expect(responsed_body[:users].first.keys).to eq(user_keys)
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
          responsed_body = JSON.parse(response.body).deep_symbolize_keys 
          expect(responsed_body[:notice]).to eq("You have not rights for this action - please sign in with necessary rights.")
          expect(responsed_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe "- GET #show" do
    before(:each) {@showed_user = create :user}

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - HTML format" do
        before(:each) { get :show, params: { id: @showed_user.id } }

        it_behaves_like "response status 200"
  
        it "- should returns a user." do
          @serialized_returned_user = serialize(assigns(:user))
          @serialized_showed_user = serialize(User.find(@showed_user.id))
          expect(@serialized_returned_user).to eql(@serialized_showed_user)
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

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - HTML format" do
        before(:each) { get :edit, params: { id: @edited_user.id } }

        it_behaves_like "response status 200"
  
        it "- should returns a user." do
          @serialized_returned_user = serialize(assigns(:user))
          @serialized_edited_user = serialize(User.find(@edited_user.id))
          expect(@serialized_returned_user).to eql(@serialized_edited_user)
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

    context " - user is saved into database" do
      context " - HTML format" do
        before(:each) { post :create, params: request_user_params(@created_user) }
  
        it "- should returns a redirectiom(:found) response status." do
          expect(response).to have_http_status(302)
        end
  
        it " - should returns a new created user." do
          @serialized_returned_user = serialize(assigns(:user))
          @serialized_created_user = serialize(@created_user)
          @serialized_created_user[:id] = @serialized_returned_user[:id] #set id for created user like returned user have (to pass comparation)
          expect(@serialized_returned_user).to eq(@serialized_created_user)
        end
  
        it " - created user should be saved into database" do
          @created_user.id = assigns(:user).id
          @serialized_created_user = serialize(@created_user)
          @serialized_saved_user = serialize(User.find(assigns(:user).id))
          expect(@serialized_saved_user).to eq(@serialized_created_user)
        end
  
        it " - should redirect to root." do  
          expect(response).to redirect_to(:root)
        end
      end
  
      context " - JSON format" do
        before(:each) { post :create, format: :json, params: request_user_params(@created_user) }
  
        it "- should returns a :created response status." do
          expect(response).to have_http_status(201)
        end
  
        it " - should returns a new created user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
          responsed_user = responsed_body[:user].first
          serialized_created_user = serialize(@created_user)
          serialized_created_user[:id] = responsed_user[:id]
  
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
          post :create, params: request_user_params(@created_user)
        end
         
        it_behaves_like "response status 200"

        it "- should render new template." do 
          expect(response).to render_template(:new)
        end
        
        it " - should return unsaved user" do
          @created_user.id = 1  #because we need to compare with assigns(:user) and for this is necessary to have some id
          assigns(:user).id = 1
          @serialized_created_user = serialize(@created_user)
          @serialized_returned_user = serialize(assigns(:user))

          expect(@serialized_returned_user).to eq(@serialized_created_user)
        end
      end

      context " - JSON format" do
        before(:each) { post :create, format: :json, params: request_user_params(@created_user) }
  
        it "- should returns a :unprocessable_entity response status." do
          expect(response).to have_http_status(422)
        end
  
        it " - should returns a uncreated user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
          responsed_user = responsed_body[:user].first
          serialized_created_user = serialize(@created_user)
  
          expect(responsed_body[:user].count).to eq(1)
          expect(responsed_body.keys).to eq([:user]) 
          expect(responsed_user). to eq(serialized_created_user)
        end
      end
    end 
  end

  describe " - PUT #update" do 
    before(:each) do
      @created_user = create :user #save some user into database
      @loaded_user = User.find(@created_user.id) #load user from database
      @modified_user = build :user
      @modified_user.id = @loaded_user.id #this user is modified user with same id like user in database
    end

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - modified user is updated in database" do
        context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_user.id, user: request_user_params(@modified_user)[:user] } } #update need to have :id in :params
    
          it "- should returns a redirection(:found) response status." do
            expect(response).to have_http_status(302)
          end
    
          it " - should returns a updated user." do
            @serialized_returned_user = serialize(assigns(:user))
            @serialized_modified_user = serialize(@modified_user)
            expect(@serialized_returned_user).to eq(@serialized_modified_user)
          end
    
          it " - user should be updated in database" do
            @updated_user = User.find(@modified_user.id)
            @serialized_updated_user = serialize(@updated_user)
            @serialized_modified_user = serialize(@modified_user)

            expect(@serialized_updated_user).to eq(@serialized_modified_user)
          end
    
          it " - should redirect to UserController #show." do  
            expect(response).to redirect_to("/users/#{@loaded_user.id}")
          end
        end
    
        context " - JSON format" do
          before(:each) { put :update, format: :json, params: { id: @loaded_user.id, user: request_user_params(@modified_user)[:user] } } #update need to have :id in :params
    
          it_behaves_like "response status 200"
    
          it " - should returns a updated user." do
            responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
            responsed_user = responsed_body[:user].first
            serialized_modified_user = serialize(@modified_user)
            serialized_modified_user[:id] = responsed_user[:id]
    
            expect(responsed_body[:user].count).to eq(1)
            expect(responsed_body.keys).to eq([:user]) 
            expect(responsed_user). to eq(serialized_modified_user)
          end

          it " - user should be updated in database" do
            @updated_user = User.find(@modified_user.id)
            @serialized_updated_user = serialize(@updated_user)
            @serialized_modified_user = serialize(@modified_user)

            expect(@serialized_updated_user).to eq(@serialized_modified_user)
          end
        end
      end

      context " - modified user isn't updated in database" do
        before(:each) {@modified_user.email = ""} #this is reason why user will not be saved into database
       
        context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_user.id, user: request_user_params(@modified_user)[:user] } } #update need to have :id in :params
    
          it_behaves_like "response status 200"

          it "- should render edit template." do  
          expect(response).to render_template(:edit)
        end
    
          it " - should returns a modified user (but not saved into database)." do
            @serialized_returned_user = serialize(assigns(:user))
            @serialized_modified_user = serialize(@modified_user)
            expect(@serialized_returned_user).to eq(@serialized_modified_user)
          end
    
          it " - user shouldn't be updated in database" do
            @serialized_not_updated_user = serialize(User.find(@loaded_user.id))
            @serialized_loaded_user = serialize(@loaded_user)
            expect(@serialized_not_updated_user).to eq(@serialized_loaded_user)
          end
        end
    
        context " - JSON format" do
          before(:each) { put :update, format: :json, params: { id: @loaded_user.id, user: request_user_params(@modified_user)[:user] } } #update need to have :id in :params
    
          it "- should returns a :unprocessable_entity response status." do
            expect(response).to have_http_status(422)
          end
    
          it " - should returns a modified user (but not saved into database)." do
            responsed_body = JSON.parse(response.body).deep_symbolize_keys #Hash
            responsed_user = responsed_body[:user].first
            serialized_modified_user = serialize(@modified_user)

            expect(responsed_body[:user].count).to eq(1)
            expect(responsed_body.keys).to eq([:user]) 
            expect(responsed_user).to eq(serialized_modified_user)
          end

          it " - user shouldn't be updated in database" do
            @not_updated_user = User.find(@loaded_user.id)
            @serialized_not_updated_user = serialize(@not_updated_user)
            @serialized_loaded_user = serialize(@loaded_user)

            expect(@serialized_not_updated_user).to eq(@serialized_loaded_user)
          end
        end
      end  
    end

    context " - without signed in user" do
      context " - HTML format" do
          before(:each) { put :update, params: { id: @loaded_user.id, user: request_user_params(@modified_user)[:user] } } #update need to have :id in :params

        it_behaves_like "unauthorized redirection examples"  
  
        it "- shouldn't returns a user." do
          expect(assigns(:user)).to eq(nil)
        end

        it " - user shouldn't be updated in database" do
          @serialized_not_updated_user = serialize(User.find(@loaded_user.id))
          @serialized_loaded_user = serialize(@loaded_user)
          expect(@serialized_not_updated_user).to eq(@serialized_loaded_user)
        end
      end

      context " - JSON format" do
        before(:each) { put :update, params: { id: @loaded_user.id, user: request_user_params(@modified_user)[:user] }, format: :json } #update need to have :id in :params
        it_behaves_like "unauthorized JSON status" 

        it "- shouldn't returns a user." do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys
          expect(responsed_body[:notice]).to eq("You have not rights for this action - please sign in with necessary rights.")
          expect(responsed_body.keys).to eq([:notice])
        end

        it " - user shouldn't be updated in database" do
          @not_updated_user = User.find(@loaded_user.id)
          @serialized_not_updated_user = serialize(@not_updated_user)
          @serialized_loaded_user = serialize(@loaded_user)

          expect(@serialized_not_updated_user).to eq(@serialized_loaded_user)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @user = create(:user)
    end

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - HTML format" do
        before(:each) {delete :destroy, params: { id: @user.id }}

        it_behaves_like "response status", 302

        it " - should redirect to root" do
          expect(response).to redirect_to(:root)
        end

        it " - should destroy a user from database" do
          expect{User.find(@user.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context " - JSON format" do
        before(:each) {delete :destroy, format: :json, params: { id: @user.id }}

        it_behaves_like "response status", 204

        it " - should destroy a user from database" do
          expect{User.find(@user.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it " - should return a notice" do
          responsed_body = JSON.parse(response.body).deep_symbolize_keys
          expect(responsed_body[:notice]).to eq("User has been destroyed.")
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) {delete :destroy, params: { id: @user.id }}

        it_behaves_like "unauthorized redirection examples"
      end

      context " - JSON format" do
        before(:each) {delete :destroy, format: :json, params: { id: @user.id }}

        it_behaves_like "unauthorized JSON status"
      end
    end
  end

  describe " - GET #pictures_show" do 
    before(:each) do
      @requested_user = create(:user, :with_profile_picture)
      sign_in(@requested_user)
    end

    context " - HTML format" do
      before(:each) { get :pictures_show, params: {id: @requested_user.id} }
      let(:serialized_returned_user) {serialize(assigns(:user))}
      let(:serialized_requested_user) {serialize(@requested_user)}

      it_behaves_like "response status", 200

      it " - should render #pictures" do
        expect(response).to render_template(:pictures)
      end

      it " - should return a user with profile_picture" do
        expect(assigns(:user).profile_picture.id).to eq(@requested_user.profile_picture.id)  #compare attachments id
        expect(serialized_returned_user).to eq(serialized_requested_user)
      end
     end

    context " - JSON format" do
      before(:each) { get :pictures_show, format: :json, params: {id: @requested_user.id} }

      let(:serialized_returned_user) {parser(response.body)[:user].first}
      let(:serialized_requested_user) {serialize(@requested_user)}

      it_behaves_like "response status", 200

      it " - should return a correct user" do
        expect(serialized_returned_user).to eq(serialized_requested_user)
      end

      it " - should return a user with profile_picture" do
        expect(serialized_returned_user[:profile_picture]).to eq(serialized_requested_user[:profile_picture])
      end
    end
  end  

  describe " - PUT #pictures_update" do 
    before(:each) {@requested_user = create(:user)}
    let(:profile_picture) { FilesTestHelper.png }

    context " - user signed in" do
      before(:each) {sign_in(@requested_user)}
      
      context " - profile picture updated" do
        context " - HTML format" do
          before(:each) do
            put :pictures_update, params: { id: @requested_user.id, user: { profile_picture: profile_picture } }
          end
          
          it_behaves_like "response status", 200
          it_behaves_like "render template", :pictures
          it_behaves_like "notice", "Profile picture has been changed."
  
          it " - should return a correct user" do
            expect(serialize(assigns(:user))).to eq(serialize(@requested_user))
          end
  
          it " - should return a user with correct profile picture" do
            expect(assigns(:user).profile_picture.attached?).to be true
            expect(assigns(:user).profile_picture.filename).to eq(FilesTestHelper.png_name)
            expect(assigns(:user).profile_picture.record_type).to eq("User")
            expect(assigns(:user).profile_picture.record_id).to eq(@requested_user.id)
          end
        end

        context " - JSON format" do
          before(:each) do
            put :pictures_update, format: :json, params: { id: @requested_user.id, user: { profile_picture: profile_picture } }          
          end
          let(:serialized_responsed_user) {parser(response.body)[:user].first}
          let(:serialized_requested_user) {serialize(@requested_user)}
          
          it_behaves_like "response status", 200
          it_behaves_like "notice", "Profile picture has been changed."
  
          it " - should return a correct user" do
            expect(serialized_responsed_user <= serialized_requested_user).to be true #requested_user has been automatically reloaded after request
          end
  
          it " - should return a user with correct profile picture" do
            expect(serialized_responsed_user[:profile_picture]).to eq(FilesTestHelper.png_name)
          end
        end
      end

      context " - profile picture not updated" do
        context " - HTML format" do
          before(:each) do
            put :pictures_update, params: { id: @requested_user.id}
          end
          
          it_behaves_like "response status", 200
          it_behaves_like "render template", :pictures
          it_behaves_like "notice", "Profile picture NOT changed!"
  
          it " - should return a correct user" do
            expect(serialize(assigns(:user))).to eq(serialize(@requested_user))
          end
  
          it " - should return a user without profile picture" do
            expect(assigns(:user).profile_picture.attached?).to be false
          end
        end

        context " - JSON format" do
          before(:each) do
            put :pictures_update, format: :json, params: { id: @requested_user.id }
          end
          let(:responsed_user) { parser(response.body)[:user].first}
          
          it_behaves_like "response status", 422
          
          it " - should return a correct user" do
            expect(responsed_user <= serialize(@requested_user)).to be true
          end
  
          it " - should return a user without profile picture" do
            expect(responsed_user[:profile_picture]).to eq({})
          end
        end
      end
    end

    context " - user not signed in" do
      context " - HTML format" do
        before(:each) do
          put :pictures_update, params: { id: @requested_user.id, user: { profile_picture: profile_picture } }
        end
        
        it_behaves_like "unauthorized redirection examples"

        it " - shouldn't return a user" do
          expect(assigns(:user)).to eq(nil)
        end
      end

      context " - JSON format" do
        before(:each) do
          put :pictures_update, format: :json, params: { id: @requested_user.id, user: { profile_picture: profile_picture } }
        end
        let(:responsed_user) { parser(response.body)[:user]}
        
        it_behaves_like "unauthorized JSON status"
        
        it " - shouldn't return a user" do
          expect(responsed_user).to be nil
        end
      end
    end
  end

  describe "- GET #show_user_works" do 
    let(:requested_user){ create(:user, :with_works, works_count: 5) }

    context " - HTML format" do
      before(:each) { get :show_user_works, params: {id: requested_user} }
      
      it_behaves_like "response status", 200

      it "- should returns user works." do
        expect(assigns(:user_works).count).to eq(5)
      end

      it "- should render show_user_works template." do  
        expect(response).to render_template(:show_user_works)
      end
    end

    context " - JSON format" do
      before(:each) {get :show_user_works, format: :json, params: {id: requested_user} }
      let(:serialized_works) {parser(response.body)[:works]}

      it_behaves_like "response status 200"

      it "- should returns a user works." do
        expect(serialized_works.count).to eq(5)
      end
    end
  end
end
