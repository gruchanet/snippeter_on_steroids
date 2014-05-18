require 'spec_helper'

describe SnippetsController do

  context "#index" do

    it "Should return 200 response code" do
      #sends get to index action
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return index template" do
      get :index
      expect(response).to render_template("index")
    end

    it "assigns snippets" do
      lang = FactoryGirl.create(:lang)
      snippet = FactoryGirl.create(:snippet, lang: lang)

      get :index
      expect(assigns(:snippets)).to eq([snippet])
    end

  end

  context "#new" do

    it "Should redirect, when not authenticated" do
      get :new
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return 200 response, when authenticated" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:user_id].should be_nil

      #Authentication
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id

      #Sends GET to create new snippet
      get :new

      expect(session[:user_id]).not_to be_nil
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return new template" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:user_id].should be_nil

      #Authentication
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id

      get :new
      expect(response).to render_template("new")
    end

  end

  context "#edit"  do

    before :each do
      lang = FactoryGirl.create(:lang)
      @snippet = FactoryGirl.create(:snippet, lang: lang)
    end

    it "Should redirect, when not authenticated" do
      get :edit, :id => @snippet.id
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return 200 response, when authenticated" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:user_id].should be_nil

      #Authentication
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id

      #Edit
      get :edit, :id => @snippet.id

      expect(session[:user_id]).not_to be_nil
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return edit template" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:user_id].should be_nil

      #Authentication
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id

      #Edit
      get :edit, :id => @snippet.id

      expect(response).to render_template("edit")
    end

  end

  context "#destroy" do

    before :each do
      @snippet = FactoryGirl.create(:snippet)
    end

    it "Should redirect, when not authenticated" do
      get :destroy, :id => @snippet.id
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return 200 response, when authenticated" do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
      session[:user_id].should be_nil

      #Authentication
      auth = request.env["omniauth.auth"]
      user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
      session[:user_id] = user.id

      #Destroy
      get :destroy, :id => @snippet.id

      expect(session[:user_id]).not_to be_nil
      response.should redirect_to snippets_url
    end

  end

end