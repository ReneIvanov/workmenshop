require 'rails_helper'

RSpec.describe LogedUserController, type: :controller do
  let(:user){ create(:user, :with_customer_account) }
  
  describe "GET #welcome" do
    context " - user signed in" do
      before(:each) { sign_in(user) }

      context " - HTML format" do
        before(:each) { get :wellcome }

        it_behaves_like "response status", 200
        it_behaves_like "render template", :wellcome
      end

      context " - JSON format" do
        before(:each) { get :wellcome, format: :json }

        it_behaves_like "response status", 200

        it " - should have empty body" do
          expect(parser(response.body)).to match({})
        end
      end
    end

    context " - without signed in user" do
      context " - HTML format" do
        before(:each) { get :wellcome }
 
        it_behaves_like "unauthorized examples HTML"  
      end
 
      context " - JSON format" do
        before(:each) {get :wellcome, format: :json}
 
        it_behaves_like "unauthorized examples JSON" 
      end
    end
  end
end
