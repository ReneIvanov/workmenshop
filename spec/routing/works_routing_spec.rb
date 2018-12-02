require "rails_helper"

RSpec.describe WorksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/works").to route_to("works#index")
    end

    it "routes to #new" do
      expect(:get => "/works/new").to route_to("works#new")
    end

    it "routes to #registration_new" do
      expect(:get => "/registration_new_work").to route_to("works#registration_new")
    end

    it "routes to #show" do
      expect(:get => "/works/1").to route_to("works#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/works/1/edit").to route_to("works#edit", :id => "1")
    end

    it "routes to #registration_edit" do
      expect(:get => "/registration_edit_work").to route_to("works#registration_edit")
    end

    it "routes to #create" do
      expect(:post => "/works").to route_to("works#create")
    end

    it "routes to #registration_create" do
      expect(:post => "/registration_create_work").to route_to("works#registration_create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/works/1").to route_to("works#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/works/1").to route_to("works#update", :id => "1")
    end

    it "routes to #registration_update" do
      expect(:post => "/registration_update_work").to route_to("works#registration_update")
    end

    it "routes to #destroy" do
      expect(:delete => "/works/1").to route_to("works#destroy", :id => "1")
    end

    it "routes to #show_work_users" do
      expect(:get => "/works/1/users").to route_to("works#show_work_users", :id => "1")
    end
  end
end
