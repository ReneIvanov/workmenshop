require 'rails_helper'

RSpec.describe UserPolicy do
  def policy(user)
    UserPolicy.new(user)
  end

  describe " - method #has_account" do
    context " - user without account" do
      let(:user){create(:user)}
      
      it " - should return false" do
        expect(policy(user).has_account).to be false
      end
    end

    context " - user with account" do
      let(:user){create(:user, :with_workmen_account)}
      
      it " - should return true" do
        expect(policy(user).has_account).to be true
      end
    end
  end

  describe " - method #is_admin" do
    context " - user is not admin" do
      let(:user){create(:user, :with_workmen_account)}
      
      it " - should return false" do
        expect(policy(user).is_admin).to be false
      end
    end

    context " - user is admin" do
      let(:user){create(:user, :with_admin_account)}
      
      it " - should return true" do
        expect(policy(user).is_admin).to be true
      end
    end
  end

  describe " - method #is_workmen" do
    context " - user is not workmen" do
      let(:user){create(:user, :with_customer_account)}
      
      it " - should return false" do
        expect(policy(user).is_workmen).to be false
      end
    end

    context " - user is workmen" do
      let(:user){create(:user, :with_workmen_account)}
      
      it " - should return true" do
        expect(policy(user).is_workmen).to be true
      end
    end
  end

  describe " - method #is_customer" do
    context " - user is not customer" do
      let(:user){create(:user, :with_workmen_account)}
      
      it " - should return false" do
        expect(policy(user).is_customer).to be false
      end
    end

    context " - user is customer" do
      let(:user){create(:user, :with_customer_account)}
      
      it " - should return true" do
        expect(policy(user).is_customer).to be true
      end
    end
  end

  describe " - method #can_see(observed_user)" do
    let(:observed_user){create(:user)}

    context " - user is not admin nor himself" do 
      let(:user){create(:user)}

      it " - should return false" do
        expect(policy(user).can_see(observed_user)).to be false
      end
    end

    context " - user is admin or himself" do 
      it " - should return true" do
        user = create(:user, :with_admin_account)
        expect(policy(user).can_see(observed_user)).to be true

        user = observed_user
        expect(policy(user).can_see(observed_user)).to be true
      end
    end
  end

  describe " - method #can_edit(edited_user)" do
    let(:edited_user){create(:user)}

    context " - user is not admin nor himself" do 
      let(:user){create(:user)}

      it " - should return false" do
        expect(policy(user).can_edit(edited_user)).to be false
      end
    end

    context " - user is admin or himself" do 
      it " - should return true" do
        user = create(:user, :with_admin_account)
        expect(policy(user).can_edit(edited_user)).to be true

        user = edited_user
        expect(policy(user).can_edit(edited_user)).to be true
      end
    end
  end

  describe " - method #can_destroy(destroyed_user)" do
    let(:destroyed_user){create(:user)}

    context " - user is not admin nor himself" do 
      let(:user){create(:user)}

      it " - should return false" do
        expect(policy(user).can_destroy(destroyed_user)).to be false
      end
    end

    context " - user is admin or himself" do 
      it " - should return true" do
        user = create(:user, :with_admin_account)
        expect(policy(user).can_destroy(destroyed_user)).to be true

        user = destroyed_user
        expect(policy(user).can_destroy(destroyed_user)).to be true
      end
    end
  end

  describe " - method #can_update_profile_picture(edited_user)" do
    let(:edited_user){create(:user)}

    context " - user is not admin nor himself" do 
      let(:user){create(:user)}

      it " - should return false" do
        expect(policy(user).can_update_profile_picture(edited_user)).to be false
      end
    end

    context " - user is admin or himself" do 
      it " - should return true" do
        user = create(:user, :with_admin_account)
        expect(policy(user).can_update_profile_picture(edited_user)).to be true

        user = edited_user
        expect(policy(user).can_update_profile_picture(edited_user)).to be true
      end
    end
  end

  describe " - method #can_create_work" do
    context " - user is not admin nor workmen" do 
      let(:user){create(:user)}

      it " - should return false" do
        expect(policy(user).can_create_work).to be false
      end
    end

    context " - user is admin or workmen" do 
      it " - should return true" do
        user = create(:user, :with_admin_account)
        expect(policy(user).can_create_work).to be true

        user = create(:user, :with_workmen_account)
        expect(policy(user).can_create_work).to be true
      end
    end
  end

  describe " - method #can_update_works" do
    context " - user is not admin nor workmen" do 
      let(:user){create(:user)}

      it " - should return false" do
        expect(policy(user).can_update_works).to be false
      end
    end

    context " - user is admin or workmen" do 
      it " - should return true" do
        user = create(:user, :with_admin_account)
        expect(policy(user).can_update_works).to be true

        user = create(:user, :with_workmen_account)
        expect(policy(user).can_update_works).to be true
      end
    end
  end
end
