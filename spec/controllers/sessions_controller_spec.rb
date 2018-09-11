require 'rails_helper'

RSpec.describe SessionsController, type: :controller do

  describe "- GET #new" do

    it "- should returns http success." do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe " - POST #create" do

    before {@user = create :person} #add user into database
    
    context " - positive session creation" do
      
      before {post :create, params: {user_name: @user.user_name, password: @user.password}}

      it " - should returns response status 302." do  
        expect(response.status).to eq(302)
      end

      it " - should redirect to loged_user_url." do
        expect(response).to redirect_to loged_user_url
      end
    end

    context " - negative session creation" do

      it " - should redirect to login_url because wrong user_name." do
        post :create, params: {user_name: "wrong user name", password: @user.password}
        expect(response).to redirect_to login_url
      end

      it " - should redirect to login_url because wrong password." do
        post :create, params: {user_name: @user.user_name, password: "wrong password"}
        expect(response).to redirect_to login_url
      end
    end    
  end

  describe "- DELETE #destroy" do

    before do
      @user = create :person #add user into database
      post :create, params: {user_name: @user.user_name, password: @user.password}
    end

    it "- session[:user_name] should be truthy." do
      expect(session[:user_name]).to be_truthy
    end

    context "- session should be destroyed" do

      before {delete :destroy}

      it " - session[:user_name] should be nil." do        
        expect(session[:user_name]).to be_nil   
      end

      it " - should redirect to root_url with notice." do 
        expect(response).to redirect_to root_url
        expect(flash[:notice]).to match("You were loged out.")
      end
    end  
  end
end