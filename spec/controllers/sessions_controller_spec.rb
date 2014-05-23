require 'spec_helper'

describe SessionsController do

  # Adds authentication parameters, to run create
  before :each do
    ActiveRecord::Base.subclasses.each(&:delete_all)
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end

  describe "#create" do

    it "should create user, but not twice" do
      expect { post :create, :provider => :github }.to change(User, :count).by 1
      expect { post :create, :provider => :github }.to change(User, :count).by 0
    end

    it "should create session" do
      session[:user_id].should be_nil
      post :create, provider: :github
      #After sending post request to create an user, expect to session to exist
      expect(session[:user_id]).not_to be_nil
    end

    it "should redirect to snippets page" do
      post :create, provider: :github
      response.should redirect_to snippets_url
    end

  end

  describe "#destroy" do

    before :each do
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
      response.should redirect_to snippets_url
    end

  end

end
