RSpec.shared_examples "response status 200" do
  it "- should returns a success response status." do
    expect(response).to have_http_status(200)
  end
end