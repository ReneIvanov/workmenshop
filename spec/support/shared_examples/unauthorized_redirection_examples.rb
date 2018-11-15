RSpec.shared_examples "unauthorized redirection examples" do
  it "- should redirect to new_user_session_path (HTML)." do       
    expect(response).to redirect_to(:new_user_session)
  end

  it "- should returns a redirect status." do
    expect(response).to have_http_status(302)
  end
end