require 'rails_helper'

RSpec.describe UserSerializer do
  
  #return a array with more serialized users
  def serialize_more_users(users)
    serialized_users = Array.new
    
    users.each do |user|
      serialized_users << { id: user.id,
                            username: user.username,
                            email: user.email,
                            address: user.address,
                            telephone: user.telephone,
                            account: AccountSerializer.new(user.account).as_json,
                            works: WorkSerializer.new(user.works).as_json,
                            profile_picture: 'test-image.png'
                          }
    end 

    return serialized_users
  end
  
  #return a array with one serialized user
  def serialize_one_user(user)
    [{ id: user.id,
      username: user.username,
      email: user.email,
      address: user.address,
      telephone: user.telephone,
      account: AccountSerializer.new(user.account).as_json,
      works: WorkSerializer.new(user.works).as_json,
      profile_picture: 'test-image.png'
    }]
  end

  context " - serialization of one correct user object" do
    context " - user with everything" do
      let(:user) { create(:user, :with_workmen_account, :with_profile_picture, :with_works, works_count: 5) }
      let(:serialized_user) { serialize_one_user(user) }

      it " - should return a array with serialized user" do
        expect(UserSerializer.new(user).as_json).to match(serialized_user)
      end
    end

    context " - user without profile picture" do
      before(:each) do
        @user = create(:user, :with_workmen_account, :with_works, works_count: 5)
        @serialized_user = serialize_one_user(@user)
        @serialized_user.first[:profile_picture] = {}
      end 

      it " - should return a array with serialized user" do
        expect(UserSerializer.new(@user).as_json).to match(@serialized_user)
      end
    end
  end

  context " - serialization of more correct users like ActiveRecord::Relation" do
    before(:each) do
      3.times.map { create(:user, :with_workmen_account, :with_profile_picture, :with_works, works_count: 5) }
      @users = User.all
      @serialized_users = serialize_more_users(@users)
    end

    it " - should return a array with serialized users" do
      expect(UserSerializer.new(@users).as_json).to match(@serialized_users)
    end
  end

  context " - serialization of unexpected object" do
    it " - should return a empty array" do
      expect(UserSerializer.new("").as_json).to match([])
      expect(UserSerializer.new(nil).as_json).to match([])
      expect(UserSerializer.new([]).as_json).to match([])
      expect(UserSerializer.new([User.new]).as_json).to match([])
      expect(UserSerializer.new([User.last]).as_json).to match([])
      expect(UserSerializer.new(Work.new).as_json).to match([])
    end
  end
end