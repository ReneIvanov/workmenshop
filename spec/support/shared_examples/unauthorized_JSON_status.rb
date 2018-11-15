RSpec.shared_examples "unauthorized JSON status" do
  it "- should returns a unauthorized status." do
    expect(response).to have_http_status(401)
  end
end