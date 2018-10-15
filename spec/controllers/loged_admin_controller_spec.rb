require 'rails_helper'

RSpec.describe LogedAdminController, type: :controller do

  describe "GET #welcome" do
   
   	before do
   		@user = create :user #add user into database
   	end

      it " - response should be successfull and equal 200." do
        get :wellcome, session: {user_name: @user.user_name, admin: true}
      	expect(response).to be_successful
      	expect(response.status).to eq(200)
      end

  end
end