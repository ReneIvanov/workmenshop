RSpec.shared_examples "unauthorized examples JSON" do
  it " - response should have a notice" do 
    expect(JSON.parse(response.body).deep_symbolize_keys[:notice]).to eq("You have not rights for this action - please sign in with necessary rights.")
  end

  it "- should returns a unauthorized status." do
    expect(response).to have_http_status(401)
  end
end