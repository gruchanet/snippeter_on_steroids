require 'spec_helper'

describe User do

  describe "#user" do
    it "returns a new User object" do
      @user = User.new
      @user.should be_an_instance_of User
    end

    it "takes github connection parameters and return User object" do
      auth = FactoryGirl.create(:user)
      @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      @user.should be_an_instance_of User
    end

    it "takes parameters and return User object" do
      auth = FactoryGirl.create(:user)
      @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      @user.name.should eql 'chuck_tester'
    end

  end

end
