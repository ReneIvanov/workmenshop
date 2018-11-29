require 'rails_helper'

RSpec.describe UserPolicy do
  def policy(work)
    WorkPolicy.new(work)
  end

  describe " - method #can_be_edited_by(user_obj)" do
    let(:work) { create(:work) }

    context " - user is not admin" do 
      it " - should return false" do
        user1 = create(:user)
        user2 = create(:user, :with_workmen_account)
        user3 = create(:user, :with_works, works_count: 5)

        expect(policy(work).can_be_edited_by(user1)).to be false
        expect(policy(work).can_be_edited_by(user2)).to be false
        expect(policy(work).can_be_edited_by(user3)).to be false
      end
    end

    context " - user is admin" do 
      let(:user) { create(:user, :with_admin_account) }

      it " - should return true" do
        expect(policy(work).can_be_edited_by(user)).to be true
      end
    end
  end

  describe " - method #can_be_destroyed_by(user_obj)" do
    let(:work) { create(:work) }

    context " - user is not admin" do 
      it " - should return false" do
        user1 = create(:user)
        user2 = create(:user, :with_workmen_account)
        user3 = create(:user, :with_works, works_count: 5)

        expect(policy(work).can_be_destroyed_by(user1)).to be false
        expect(policy(work).can_be_destroyed_by(user2)).to be false
        expect(policy(work).can_be_destroyed_by(user3)).to be false
      end
    end

    context " - user is admin" do 
      let(:user) { create(:user, :with_admin_account) }

      it " - should return true" do
        expect(policy(work).can_be_destroyed_by(user)).to be true
      end
    end
  end
end
