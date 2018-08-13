require 'rails_helper'

RSpec.describe "people/edit", type: :view do
  before(:each) do
    @person = assign(:person, Person.create!(
      :name => "MyString",
      :address => "MyString",
      :workmen => false,
      :customer => false,
      :image_url => "MyString",
      :email => "MyString",
      :telephone => "MyString"
    ))
  end

  it "renders the edit person form" do
    render

    assert_select "form[action=?][method=?]", person_path(@person), "post" do

      assert_select "input[name=?]", "person[name]"

      assert_select "input[name=?]", "person[address]"

      assert_select "input[name=?]", "person[workmen]"

      assert_select "input[name=?]", "person[customer]"

      assert_select "input[name=?]", "person[image_url]"

      assert_select "input[name=?]", "person[email]"

      assert_select "input[name=?]", "person[telephone]"
    end
  end
end
