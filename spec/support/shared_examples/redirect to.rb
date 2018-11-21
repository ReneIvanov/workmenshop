RSpec.shared_examples "redirect to" do |action| 
  it "- should redirect to #{action}." do       
    expect(response).to redirect_to(action)
  end
end
