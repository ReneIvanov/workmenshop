RSpec.shared_examples "session" do |key, value|
  it "- should returns a session." do
    expect(session[:key]).to eq(value)
  end
end