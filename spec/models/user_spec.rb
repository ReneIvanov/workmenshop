require 'rails_helper'

RSpec.describe User, type: :model do
  #pending "add some examples to (or delete) #{__FILE__}"
  describe "- durring creation" do
    context "- valid creation" do
      before do
        @count = User.count
        create :user
      end

      it "- should be created." do
        expect(User.count).to eq(@count+1)
      end

      it "- should be valid." do
        expect(User.last.valid?).to eq(true)
      end
    end

    context "- default user details" do
      let(:user1) { create :user }
      let(:user2) { create :user }

      it '- should be initialize with relevant informations.' do
        [user1, user2].each do |user|
          expect(user.username).to include("User")
          expect(user.address).to include("Address")
          expect(user.email).to include("user" && "@" && "gmail.com")
          expect(user.telephone).to eq("1111 111 111")
          expect(user.password).to eq("xxxx")
        end
      end
    end
  end
end
