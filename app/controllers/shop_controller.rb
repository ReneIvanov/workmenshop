class ShopController < ApplicationController

  skip_before_action :authorize_admin, only: [:index]
  skip_before_action :authorize_user

  def index
  end
end
