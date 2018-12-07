RSpec.shared_examples "unauthorized examples HTML" do
  it_behaves_like "session", "message_unauthorized" "You have not rights for this action - please sign in with necessary rights."
  it_behaves_like "response status", 302
  it_behaves_like "redirect to", :new_user_session
end
