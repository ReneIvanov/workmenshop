require 'rails_helper'

RSpec.describe User, type: :model do
  describe "- creation" do
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
      let(:user) { create :user }

      it "- should be initialize with relevant informations." do
        expect(user.username).to be_instance_of(String)
        expect(user.address).to be_instance_of(String)
        expect(user.email).to be_instance_of(String) && include("@")
        expect(user.telephone).to be_instance_of(String)
        expect(user.password).to be_instance_of(String)
      end
    end

    context " - invalid creation" do
      before(:each) {@user = create :user}
      after(:each) {@user.destroy}

      it " - invalid username" do
        expect(@user.valid?).to eq(true)

        @user.username = ""
        expect(@user.valid?).to eq(false)
      end

      it " - invalid email" do
        expect(@user.valid?).to eq(true)

        @user.email = ""
        expect(@user.valid?).to eq(false)
      end

      it " - invalid password" do
        expect(@user.valid?).to eq(true)

        @user.password = ""
        expect(@user.valid?).to eq(false)
      end
    end
  end

  describe " - associations" do
    let(:user) { create :user }
    
    context " - works" do
      it " - associated works don't exist." do
        expect(user.works.count).to eq(0)
      end

      it " - associated works exist." do
        user.works << create(:work)
        expect(user.works.count).to eq(1)
        expect(user.works.last).to be_instance_of(Work)
      end
    end

    context " - account" do
      it " - associated account don't exist." do
        expect(user.account).to eq(nil)
      end

      it " - associated account exist." do
        create(:account_customer, user_id: user.id)
        expect(user.account).to be_instance_of(Account)
      end
    end
  end

  describe " - methods" do
    let(:user) { create :user }

    it " - update_existed_works." do
      expect(user.work_ids.count).to eq(0)

      user.update_existed_works([create(:work).id])
      expect(user.work_ids.count).to eq(1)
      expect(user.works.last).to be_instance_of(Work)
      expect(user.works.last.id).to eq(Work.last.id)
    end

    it " - user_works." do
      expect(user.user_works.count).to eq(0)

      works_array = create_list(:work, 5)
      user.works << works_array
      
      expect(user.user_works).to eq(works_array)
    end
  end
end
