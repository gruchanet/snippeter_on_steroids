require 'spec_helper'

describe SessionsController do

  #Adds authentication parameters, to run create
  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end

  describe "#create" do

    it "should create user" do
      count = User.count
      #Sends post request for create action
      post :create, provider: :github
      #expects there will be one more than before
      expect(User.count).to eq(count+1)
    end

    it "should create session" do
      session[:user_id].should be_nil
      post :create, provider: :github
      #After sending post request to create an user, expect to session to exist
      expect(session[:user_id]).not_to be_nil
    end

    it "should redirect to root_url" do
      post :create, provider: :github
      response.should redirect_to root_url
    end

  end

  describe "#destroy" do

    before do
      post :create, provider: :github
    end

    it "should clear the session" do
      expect(session[:user_id]).not_to be_nil
      delete :destroy
      #After sending post request session should be null
      expect(session[:user_id]).to be_nil
    end

    it "should redirect to the home page" do
      delete :destroy
      response.should redirect_to root_url
    end
    
  end

end
