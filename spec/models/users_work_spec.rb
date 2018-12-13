require 'rails_helper'

RSpec.describe UsersWork, type: :model do
  describe "- creation" do
    context "- valid creation" do
      let(:user) { create(:user) }
      let(:work) { create(:work) }

      it " - should be created and valid - 1." do
        user.works << work
        expect(UsersWork.count).to eq(1)
        expect(UsersWork.last.valid?).to eq(true)
        expect(user.works.first).to eq(work)
      end

      it " - should be created and valid - 2." do
        work.users << user
        expect(UsersWork.count).to eq(1)
        expect(UsersWork.last.valid?).to eq(true)
        expect(work.users.first).to eq(user)
      end
    end

    context " - not created" do
      let(:user) { create(:user) }
      let(:work) { create(:work) }

      it " - shouldn't be created." do
        expect(UsersWork.count).to eq(0)
      end
    end
  end

  describe " - associations test (user has 5 works)" do
    let(:user) { create :user }
    let(:works) { create_list(:work, 5) }
    before(:each) { user.works << works}
    
    it " - should be saved into users table." do
      expect(User.count).to eq(1)
    end

    it " - should be saved into works table." do
      expect(Work.count).to eq(5)
    end

    it " - should be saved into users_works table." do
      expect(UsersWork.count).to eq(5)
    end

    it " - should be associated user with works" do
      expect(compare_arrays_of_hashes(serialize(user.works), serialize(works))).to be true
    end

    it " - work should be properly added" do
      added_work = create(:work)
      user.works << added_work

      expect(user.works.last).to eq(added_work)
      expect(UsersWork.last.work).to eq(added_work)
      expect(Work.last).to eq(added_work)
      expect(Work.count).to eq(6)
    end
    
    it " - work should be properly updated" do
      work_attributes = attributes_for(:work)
      Work.last.update(work_attributes)

      expect(user.works.last.title).to eq(work_attributes[:title])
      expect(UsersWork.last.work).to eq(Work.last)
      expect(Work.last.title).to eq(work_attributes[:title])
      expect(Work.count).to eq(5)
    end

    it " - work should be properly destroyed" do
      Work.last.destroy

      expect(Work.count).to eq(4)
      expect(user.works.count).to eq(4)
      expect(UsersWork.count).to eq(4)
    end
  end

  describe " - associations test (work has 5 users)" do
    let(:users) { create_list(:user, 5) }
    let(:work) { create(:work) }
    before(:each) { work.users << users}
    
    it " - should be saved into users table." do
      expect(User.count).to eq(5)
    end

    it " - should be saved into works table." do
      expect(Work.count).to eq(1)
    end

    it " - should be saved into users_works table." do
      expect(UsersWork.count).to eq(5)
    end

    it " - should be associated work with users" do
      expect(compare_arrays_of_hashes(serialize(work.users), serialize(users))).to be true
    end

    it " - user should be properly added" do
      added_user = create(:user)
      work.users << added_user

      expect(work.users.last).to eq(added_user)
      expect(UsersWork.last.user).to eq(added_user)
      expect(User.last).to eq(added_user)
      expect(User.count).to eq(6)
    end
    
    it " - user should be properly updated" do
      user_attributes = attributes_for(:user)
      User.last.update(user_attributes)

      expect(work.users.last.username).to eq(user_attributes[:username])
      expect(UsersWork.last.user).to eq(User.last)
      expect(User.last.username).to eq(user_attributes[:username])
      expect(User.count).to eq(5)
    end

    it " - user should be properly destroyed" do
      User.last.destroy

      expect(User.count).to eq(4)
      expect(work.users.count).to eq(4)
      expect(UsersWork.count).to eq(4)
    end
  end
end