RSpec.shared_examples "response status" do |status|
  it "- should returns a #{status} response status." do
    expect(response).to have_http_status(status)
  end
end
