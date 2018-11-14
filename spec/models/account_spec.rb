require 'rails_helper'

RSpec.describe Account, type: :model do
  describe "- creation" do
    context "- valid creation" do
      before do
        @count = Account.count
        create :account_customer
      end

      it "- should be created." do
        expect(Account.count).to eq(@count+1)
      end

      it "- should be valid." do
        expect(Account.last.valid?).to eq(true)
      end
    end
    
    context "- default account details" do
      let(:account) { create :account_customer }

      it "- should be initialize with relevant informations." do
        expect(account.user_id).to be_instance_of(Integer)
        expect(account.customer).to be_in([true, false, nil])
        expect(account.workmen).to be_in([true, false, nil])
        expect(account.admin).to be_in([true, false, nil])
      end
    end

    context " - invalid creation" do
      before(:each) {@account = create :account_customer}
      after(:each) {@account.destroy}

      it " - customer,workmen nor admin is not checked." do
        expect(@account.valid?).to eq(true)

        @account.customer = "false"
        @account.workmen = "false"
        @account.admin = "false"
        expect(@account.valid?).to eq(false)
      end
    end
  end

  describe " - associations" do
    before(:each) {@account = create :account_customer}
    after(:each) {@account.destroy}
    
    context " - user" do
      it " - change associated user." do
        @account.user_id = create(:user).id
        expect(@account.user).to eq(User.last)
      end

      it " - delete associated account from database when user is deletes form database." do
        expect(Account.last).to be_instance_of(Account)

        @account.user.destroy
        expect(Account.last).to eq(nil)
      end
    end
  end

  describe " - methods" do
    let(:account) { create :account_customer }

    it " - atleast_one_is_checked." do
      expect(account.atleast_one_is_checked).to eq(nil)

      account.customer = "false"
      account.workmen = "false"
      account.admin = "false"
      expect(account.atleast_one_is_checked).to eq(["Select atleast one output format type"])
    end
  end
end
