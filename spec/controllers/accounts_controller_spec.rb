require 'rails_helper'

RSpec.describe AccountsController, type: :controller do
  describe "- GET #index" do
    before(:each) { @accounts_in_database = create_list(:account_customer, 5) }
    let(:serialized_accounts_in_database){ serialize(@accounts_in_database) }

    context " - HTML format" do
      before(:each) {get :index}
      let(:serialized_returned_accounts){ serialize(assigns(:accounts)) }

      it_behaves_like "response status", 200
      it_behaves_like "render template", :index

      it "- should returns a list of accounts." do
        expect(compare_arrays_of_hashes(serialized_returned_accounts, serialized_accounts_in_database)).to be true
      end
    end

    context " - JSON format" do
      before(:each) {get :index, format: :json}
      let(:serialized_returned_accounts){ parser(response.body)[:accounts] }

      it_behaves_like "response status", 200
      
      it "- should returns a list of accounts." do
        expect(compare_arrays_of_hashes(serialized_returned_accounts, serialized_accounts_in_database)).to be true
      end
    end 
  end

  describe "- GET #show" do
    before(:each) {@requested_account = create :account_workmen}

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - HTML format" do
        before(:each) { get :show, params: { public_uid: @requested_account.public_uid } }

        it_behaves_like "response status", 200
        it_behaves_like "render template", :show
  
        it "- should returns a account." do
          @serialized_returned_account = serialize(assigns(:account))
          @serialized_requested_account = serialize(@requested_account)
          expect(@serialized_returned_account).to match(@serialized_requested_account)
        end
      end

      context " - JSON format" do
        before(:each) {get :show, params: { public_uid: @requested_account.public_uid }, format: :json}

        it_behaves_like "response status", 200

        it "- should returns a account." do
          serialized_returned_account = parser(response.body)[:account].first
          serialized_requested_account = serialize(@requested_account)
        
          expect(serialized_returned_account).to match(serialized_requested_account) 
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :show, params: { public_uid: @requested_account.public_uid } }

        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a account." do
          expect(assigns(:account)).to eq(nil)
        end
      end

      context " - JSON format" do
        before(:each) {get :show, params: { public_uid: @requested_account.public_uid }, format: :json}

        it_behaves_like "unauthorized examples JSON" 

        it "- shouldn't returns a account." do
          serialized_response_body = parser(response.body)
        
          expect(serialized_response_body.keys).to match([:notice])
        end
      end
    end
  end

  describe "- GET #new" do 
    context " - HTML format" do
      before(:each) { get :new }
      
      it_behaves_like "response status", 200
      it_behaves_like "render template", :new

      it "- should returns a new account." do
        expect(assigns(:account).id).to eq(nil)
      end
    end

    context " - JSON format" do
      before(:each) {get :new, format: :json}

      it_behaves_like "response status", 200

      it "- should returns a new account." do
        serialized_returned_account = parser(response.body)[:account].first
        
        expect(serialized_returned_account[:id]).to be nil 
      end
    end
  end

  describe "- GET #edit" do
    before(:each) {@requested_account = create :account_workmen}
 
    context " - admin signed in" do
      before(:each) {sign_in_admin}
 
      context " - HTML format" do
        before(:each) { get :edit, params: { public_uid: @requested_account.public_uid } }
 
        it_behaves_like "response status", 200
        it_behaves_like "render template", :edit
  
        it "- should returns a account." do
          serialized_returned_account = serialize(assigns(:account))
          serialized_requested_account = serialize(@requested_account)
 
          expect(serialized_returned_account).to match(serialized_requested_account)
        end
      end
 
      context " - JSON format" do
        before(:each) {get :edit, params: { public_uid: @requested_account.public_uid }, format: :json}
 
        it_behaves_like "response status", 200
 
        it "- should returns a account." do
          serialized_returned_account = parser(response.body)[:account].first
          serialized_requested_account = serialize(@requested_account)
 
          expect(serialized_returned_account <= serialized_requested_account).to be true
        end
      end
    end
 
    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :edit, params: { public_uid: @requested_account.public_uid } }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a account." do
          expect(assigns(:account)).to eq(nil)
        end
      end
 
      context " - JSON format" do
        before(:each) {get :edit, params: { public_uid: @requested_account.public_uid }, format: :json}
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns a account." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe " - POST #create" do 
    before(:each) do
      @user = create(:user, :with_customer_account)
      @new_account_attributes = attributes_for(:account_workmen)
    end
      
    context " - user without account is signed in" do
      before(:each) do
        @user2 = create(:user)
        sign_in(@user2)
        post :create, params: { account: @new_account_attributes }
      end

      it " - user should have new account" do
        expect(@user2.account).to eq(assigns(:account))
      end  
    end

    context " - user with account is signed in" do
      before(:each) {sign_in(@user)}

      context " - new account is saved into database" do
        context " - HTML format" do
          before(:each) { post :create, params: { account: @new_account_attributes } }
    
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Please continue with specifing your services."
          it_behaves_like "redirect to", "/registration_new_work"
    
          it " - should returns a new created account." do
            serialized_returned_account = serialize(assigns(:account))
            @new_account_attributes[:user_id] = serialized_returned_account[:user_id]
            @new_account_attributes.merge!( { id: serialized_returned_account[:id] } )

            expect(serialized_returned_account).to match(@new_account_attributes)
          end

          it " - created new account should be saved into database" do
            @new_account_attributes[:user_id] = assigns(:account).user_id
            @new_account_attributes.merge!( { id: assigns(:account)[:id] } )
            serialized_saved_account = serialize(Account.find(assigns(:account).id))

            expect(serialized_saved_account).to match(@new_account_attributes)
          end

          it " - user should have new account" do
            @user.reload
            expect(@user.account).to eq(assigns(:account))
          end  
        end
    
        context " - JSON format" do
          before(:each) { post :create, format: :json, params: { account: @new_account_attributes } }
          
          it_behaves_like "response status", 201
          
          it " - should return a notice" do
            response_body = parser(response.body)
            expect(response_body[:notice]).to eq("Your account was succefully created.")
          end
          
          it " - should returns a new created account." do
            serialized_returned_account = parser(response.body)[:account].first
            @new_account_attributes[:user_id] = serialized_returned_account[:user_id]
            @new_account_attributes.merge!( { id: serialized_returned_account[:id] } )
    
            expect(serialized_returned_account <= @new_account_attributes). to be true
          end

          it " - user should have new account" do
            @user.reload
            serialized_user_account = serialize(@user.account)
            serialized_returned_account = parser(response.body)[:account].first

            expect(serialized_returned_account <= serialized_user_account).to be true
          end  
        end
      end
  
      context " - account isn't saved into database" do
        before(:each) do     #this is reason why account will not be saved into database
          @new_account_attributes[:workmen] = false
          @new_account_attributes[:customer] = false
        end
  
        context " - HTML format" do
          before(:each) {post :create, params: { account: @new_account_attributes } }
           
          it_behaves_like "response status", 200
          it_behaves_like "notice", "Account was not created."
          it_behaves_like "render template", :new
          
          it " - should return unsaved account" do
            @new_account_attributes[:user_id] = assigns(:account).user_id
            @new_account_attributes.merge!( { id: 1 } )
            assigns(:account).id = 1
            serialized_returned_account = serialize(assigns(:account))

            expect(serialized_returned_account).to match(@new_account_attributes)
          end
        end
  
        context " - JSON format" do
          before(:each) { post :create, format: :json, params: { account: @new_account_attributes } }
    
          it_behaves_like "response status", 422
  
          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Account was not created.")
          end
    
          it " - should returns a unsaved account." do
            response_body = parser(response.body)
            serialized_returned_account = response_body[:account].first
            @new_account_attributes[:user_id] = serialized_returned_account[:user_id]
            serialized_returned_account[:id] = 1
            @new_account_attributes.merge!( { id: 1 } )
    
            expect(response_body[:account].count).to eq(1)
            expect(response_body.keys).to eq([:account, :notice])
            expect(serialized_returned_account).to match(@new_account_attributes)
          end
        end
      end 
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { post :create, params: { account: @new_account_attributes } }
 
        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a account." do
          expect(assigns(:account)).to eq(nil)        end
      end
 
      context " - JSON format" do
        before(:each) { post :create, format: :json, params: { account: @new_account_attributes } }
 
        it_behaves_like "unauthorized examples JSON" 
 
        it "- shouldn't returns account." do
          response_body = parser(response.body)

          expect(response_body.keys).to eq([:notice])
        end
      end
    end
  end

  describe " - PUT #update" do 
    before(:each) do
      @created_account = create :account_customer #save some account into database
      @loaded_account = Account.find(@created_account.id) #load account from database
      @modified_account = build :account_workmen
      @modified_account.id = @loaded_account.id #modified account has the same id like account in database
    end

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - modified account is updated in database" do
        context " - HTML format" do
          before(:each) { put :update, params: { public_uid: @loaded_account.public_uid, account: serialize(@modified_account) } } #update need to have :id in :params
    
          it_behaves_like "response status", 302
          it_behaves_like "notice", "Account was successfully updated."

          it " - should redirect to registration_edit_work" do
            expect(response).to redirect_to("/registration_edit_work")
          end
    
          it " - should returns a updated account." do
            serialized_returned_account = serialize(assigns(:account))
            serialized_modified_account = serialize(@modified_account)
            serialized_modified_account[:user_id] = serialized_returned_account[:user_id]

            expect(serialized_returned_account).to match(serialized_modified_account)
          end
    
          it " - account should be updated in database" do
            updated_account = Account.find(@modified_account.id)
            serialized_updated_account = serialize(updated_account)
            serialized_modified_account = serialize(@modified_account)
            serialized_modified_account[:user_id] = serialized_updated_account[:user_id]

            expect(serialized_updated_account).to eq(serialized_modified_account)
          end
        end
    
        context " - JSON format" do
          before(:each) { put :update, format: :json, params: { public_uid: @loaded_account.public_uid, account: serialize(@modified_account) } } #update need to have :id in :params
    
          it_behaves_like "response status", 200

          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Account was successfully updated.")
          end
    
          it " - should returns a updated account." do
            response_body = parser(response.body)
            returned_account = response_body[:account].first
            serialized_modified_account = serialize(@modified_account)
            serialized_modified_account[:id] = returned_account[:id]
            serialized_modified_account[:user_id] = returned_account[:user_id]
    
            expect(response_body[:account].count).to eq(1)
            expect(response_body.keys).to eq([:account, :notice]) 
            expect(returned_account).to match(serialized_modified_account)
          end

          it " - account should be updated in database" do
            updated_account = Account.find(@modified_account.id)
            serialized_updated_account = serialize(updated_account)
            serialized_modified_account = serialize(@modified_account)
            serialized_modified_account[:user_id] = serialized_updated_account[:user_id]

            expect(serialized_updated_account).to match(serialized_modified_account)
          end
        end
      end

      context " - modified account isn't updated in database" do
        before(:each) {@modified_account.workmen = false} #this is reason why account will not be saved into database
       
        context " - HTML format" do
          before(:each) { put :update, params: { public_uid: @loaded_account.public_uid, account: serialize(@modified_account) } } #update need to have :id in :params
    
          it_behaves_like "response status", 200
          it_behaves_like "render template", :edit
          it_behaves_like "notice", "Account was not updated."
    
          it " - should returns a modified account (but not saved into database)." do
            serialized_returned_account = serialize(assigns(:account))
            serialized_modified_account = serialize(@modified_account)
            expect(@serialized_returned_account).to match(@serialized_modified_account)
          end
    
          it " - account shouldn't be updated in database" do
            serialized_not_updated_account = serialize(Account.find(@loaded_account.id))
            serialized_loaded_account = serialize(@loaded_account)
            expect(serialized_not_updated_account).to match(serialized_loaded_account)
          end
        end
    
        context " - JSON format" do
          before(:each) { put :update, format: :json, params: { public_uid: @loaded_account.public_uid, account: serialize(@modified_account) } } #update need to have :id in :params
    
          it_behaves_like "response status", 422

          it " - should return a notice" do
            expect(parser(response.body)[:notice]).to eq("Account was not updated.")
          end
    
          it " - should returns a modified account (but not saved into database)." do
            response_body = parser(response.body)
            returned_account = response_body[:account].first
            serialized_modified_account = serialize(@modified_account)
            serialized_modified_account[:user_id] = returned_account[:user_id]

            expect(response_body[:account].count).to eq(1)
            expect(response_body.keys).to eq([:account, :notice]) 
            expect(returned_account).to eq(serialized_modified_account)
          end

          it " - account shouldn't be updated in database" do
            not_updated_account = Account.find(@loaded_account.id)
            serialized_not_updated_account = serialize(not_updated_account)
            serialized_loaded_account = serialize(@loaded_account)

            expect(serialized_not_updated_account).to match(serialized_loaded_account)
          end
        end
      end  
    end

    context " - without signed in admin" do
      context " - HTML format" do
          before(:each) { put :update, params: { public_uid: @loaded_account.public_uid, account: serialize(@modified_account) } } #update need to have :id in :params

        it_behaves_like "unauthorized examples HTML"  
  
        it "- shouldn't returns a account." do
          expect(assigns(:account)).to eq(nil)
        end

        it " - account shouldn't be updated in database" do
          serialized_not_updated_account = serialize(Account.find(@loaded_account.id))
          serialized_loaded_account = serialize(@loaded_account)
          expect(serialized_not_updated_account).to eq(serialized_loaded_account)
        end
      end

      context " - JSON format" do
        before(:each) { put :update, params: { public_uid: @loaded_account.public_uid, account: serialize(@modified_account) }, format: :json } #update need to have :id in :params
        it_behaves_like "unauthorized examples JSON" 

        it "- shouldn't returns a account." do
          response_body = parser(response.body)
          expect(response_body.keys).to eq([:notice])
        end

        it " - account shouldn't be updated in database" do
          not_updated_account = Account.find(@loaded_account.id)
          serialized_not_updated_account = serialize(not_updated_account)
          serialized_loaded_account = serialize(@loaded_account)

          expect(serialized_not_updated_account).to eq(serialized_loaded_account)
        end
      end
    end
  end

  describe "DELETE #destroy" do
    before(:each) do
      @account = create(:account_workmen)
    end

    context " - admin signed in" do
      before(:each) {sign_in_admin}

      context " - HTML format" do
        before(:each) {delete :destroy, params: { public_uid: @account.public_uid }}

        it_behaves_like "response status", 302
        it_behaves_like "redirect to", :root
        it_behaves_like "notice", "Account was destroyed."

        it " - should destroy a account from database" do
          expect{Account.find(@account.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context " - JSON format" do
        before(:each) {delete :destroy, format: :json, params: { public_uid: @account.public_uid }}

        it_behaves_like "response status", 204

        it " - should destroy a account from database" do
          expect{Account.find(@account.id)}.to raise_error(ActiveRecord::RecordNotFound)
        end

        it " - should return a notice" do
          response_body = parser(response.body)
          expect(response_body[:notice]).to eq("Account was destroyed.")
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) {delete :destroy, params: { public_uid: @account.public_uid }}

        it_behaves_like "unauthorized examples HTML"

        it " - account shouldn't be destroyed." do
          expect(Account.find(@account.id).blank?).to be false
        end
      end

      context " - JSON format" do
        before(:each) {delete :destroy, format: :json, params: { public_uid: @account.public_uid }}

        it_behaves_like "unauthorized examples JSON"

        it " - account shouldn't be destroyed." do
          expect(Account.find(@account.id).blank?).to be false
        end
      end
    end
  end
end