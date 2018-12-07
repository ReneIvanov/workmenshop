require 'rails_helper'

RSpec.describe AccountSerializer do
  
  #return a array with more serialized accounts
  def serialize_more_accounts(accounts)
    serialized_accounts = Array.new
    
    accounts.each do |account|
      serialized_accounts << { public_uid: account.public_uid,
                               customer: account.customer,
                               workmen: account.workmen,
                               admin: account.admin,
                               user_id: account.user_id
                             }
    end 

    return serialized_accounts
  end
  
  #return a array with one serialized account
  def serialize_one_account(account)
    [{ public_uid: account.public_uid,
       customer: account.customer,
       workmen: account.workmen,
       admin: account.admin,
       user_id: account.user_id
    }]
  end

  context " - serialization of one correct account object" do
    context " - account with everything" do
      let(:account) { create(:account_customer)}
      let(:serialized_account) { serialize_one_account(account) }

      it " - should return a array with serialized account" do
        expect(AccountSerializer.new(account).as_json).to match(serialized_account)
      end
    end

    context " - account without user_id" do
      before(:each) do
        @account = create(:account_customer)
        @account.user_id = nil
        @serialized_account = serialize_one_account(@account)
      end 

      it " - should return a array with serialized account" do
        expect(AccountSerializer.new(@account).as_json).to match(@serialized_account)
      end
    end
  end

  context " - serialization of more correct accounts like ActiveRecord::Relation" do
    before(:each) do
      create(:account_customer) 
      create(:account_workmen)
      create(:account_admin)
      @accounts = Account.all
      @serialized_accounts = serialize_more_accounts(@accounts)
    end

    it " - should return a array with serialized accounts" do
      expect(AccountSerializer.new(@accounts).as_json).to match(@serialized_accounts)
    end
  end

  context " - serialization of unexpected object" do
    it " - should return a empty array" do
      expect(AccountSerializer.new("").as_json).to match([])
      expect(AccountSerializer.new(nil).as_json).to match([])
      expect(AccountSerializer.new([]).as_json).to match([])
      expect(AccountSerializer.new([Account.new]).as_json).to match([])
      expect(AccountSerializer.new([Account.last]).as_json).to match([])
      expect(AccountSerializer.new(Work.new).as_json).to match([])
    end
  end
end