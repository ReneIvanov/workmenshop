=begin
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
 
  controller do

  	def aaa
  		render text: 'Hello World'
  	end
  end

  describe "aaa" do
  	
  	it "aaa" do
  	  get :aaa
	  expect(response.body).to include('Hello World')
	end
  end
end
=end




=begin
require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

  describe "- GET #authorize_user" do

  	before do
  		@user = create :person #add user into database
  		session[:user_name] = "@user.user_name"
  	end

    it "- should returns http success." do
      
      #get :authorize_user, session: {user_name: @user.user_name}
      expect(subject.authorize_user).to eq(nil)
    end
  end
end
=end