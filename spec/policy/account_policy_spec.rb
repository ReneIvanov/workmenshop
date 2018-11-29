require 'rails_helper'

RSpec.describe AccountPolicy do
  def policy(account)
    AccountPolicy.new(account)
  end

  describe " - method #can_be_seen_by(user_obj)" do
    let(:account){create(:account_customer)}

    context " - user is not admin nor himself" do 
      let(:user){create(:user, :with_workmen_account)}

      it " - should return false" do
        expect(policy(account).can_be_seen_by(user)).to be false
      end
    end

    context " - user is admin or himself" do 
      it " - should return true" do
        user1 = create(:user, :with_admin_account)
        user2 = account.user

        expect(policy(account).can_be_seen_by(user1)).to be true
        expect(policy(account).can_be_seen_by(user2)).to be true
      end
    end
  end
end
