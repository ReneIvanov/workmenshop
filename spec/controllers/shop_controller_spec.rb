require 'rails_helper'

RSpec.describe ShopController, type: :controller do
  describe " - GET #index" do
    before do
      get :index
    end

    it "- should returns http success." do
      expect(response).to have_http_status(:success)
    end

    it "- should returns response status 200." do
      expect(response.status).to eq(200)
    end
  end
end
