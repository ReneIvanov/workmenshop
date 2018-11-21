RSpec.shared_examples "render template" do |template|
  it "- should render #{template}." do
    expect(response).to render_template(template)
  end
end
