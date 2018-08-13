require 'rails_helper'

RSpec.describe "people/index", type: :view do
  before(:each) do
    assign(:people, [
      Person.create!(
        :name => "Name",
        :address => "Address",
        :workmen => false,
        :customer => false,
        :image_url => "Image Url",
        :email => "Email",
        :telephone => "Telephone"
      ),
      Person.create!(
        :name => "Name",
        :address => "Address",
        :workmen => false,
        :customer => false,
        :image_url => "Image Url",
        :email => "Email",
        :telephone => "Telephone"
      )
    ])
  end

  it "renders a list of people" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => "Image Url".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
    assert_select "tr>td", :text => "Telephone".to_s, :count => 2
  end
end
