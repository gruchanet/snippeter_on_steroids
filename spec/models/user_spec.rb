require 'spec_helper'

describe User do

  describe "#user" do
    it "returns a new User object" do
      @user = User.new
      @user.should be_an_instance_of User
    end

    context "takes user parameters" do
      before :each do
        auth = OmniAuth.config.mock_auth[:github]
        @user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      end

      it "should return instance of User" do
        @user.should be_an_instance_of User
      end

      it "should rerturn User with correct name" do
        @user.name.should eql 'chuck_tester'
      end
    end
  end
end
