require 'rails_helper'

RSpec.describe LogedAdminController, type: :controller do

  describe "GET #wellcome" do
    it "returns http success" do
      get :wellcome
      expect(response).to have_http_status(:success)
    end
  end

end
