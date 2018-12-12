require 'rails_helper'

RSpec.describe Work, type: :model do
  describe "- creation" do
    context "- valid creation" do
      before do
        @count = Work.count
        create :work
      end

      it "- should be created." do
        expect(Work.count).to eq(@count+1)
      end

      it "- should be valid." do
        expect(Work.last.valid?).to eq(true)
      end
    end
    
    context "- default work details" do
      let(:work) { create :work }

      it "- should be initialize with relevant informations." do
        expect(work.title).to be_instance_of(String)
      end
    end

    context " - invalid creation" do
      before(:each) {@work = create :work}
      after(:each) {@work.destroy}

      it " - invalid title." do
        expect(@work.valid?).to eq(true)

        @work.title = ""
        expect(@work.valid?).to eq(false)
      end
    end
  end

  describe " - associations" do
    let(:work) { create :work }
    
    context " - user" do
      it " - associated users don't exist." do
        expect(work.users.count).to eq(0)
      end

      it " - associated users exist." do
        work.users << create(:user)
        expect(work.users.count).to eq(1)
        expect(work.users.last).to be_instance_of(User)
      end
    end
  end

  describe " - methods" do
    let(:work) { create :work }

    it " - add_user." do
      expect(work.user_ids.count).to eq(0)

      work.add_user(create(:user))
      expect(work.users.count).to eq(1)
      expect(work.users.last).to be_instance_of(User)
      expect(work.users.last.id).to eq(User.last.id)
    end

    it " - work_users." do
      expect(work.work_users.count).to eq(0)

      users_array = create_list(:user, 5)
      work.users << users_array

      expect(work.work_users).to eq(users_array)
    end
  end
end
