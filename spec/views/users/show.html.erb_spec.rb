=begin
require 'rails_helper'

RSpec.describe "people/show", type: :view do
  before(:each) do
    @person = assign(:person, Person.create!(
      :name => "Name",
      :address => "Address",
      :workmen => false,
      :customer => false,
      :image_url => "Image Url",
      :email => "Email",
      :telephone => "Telephone"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/Image Url/)
    expect(rendered).to match(/Email/)
    expect(rendered).to match(/Telephone/)
  end
end
=end