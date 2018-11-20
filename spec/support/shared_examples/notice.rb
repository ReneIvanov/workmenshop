RSpec.shared_examples "notice" do |notice|
  it "- should returns a notice." do
    expect(flash[:notice]).to eq(notice)
  end
end