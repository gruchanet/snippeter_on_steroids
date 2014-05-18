require 'spec_helper'

describe SnippetsController do

  before :each, :auth => true do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
    session[:user_id].should be_nil

    #Authentication
    auth = request.env["omniauth.auth"]
    user = User.find_by_provider_and_uid(auth["provider"], auth["uid"]) || User.create_with_omniauth(auth)
    session[:user_id] = user.id
  end

  context "#index" do

    before :each do
      get :index
    end

    it "Should return 200 response code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return index template" do
      expect(response).to render_template("index")
    end

    it "assigns snippets" do
      lang = FactoryGirl.create(:lang)
      snippet = FactoryGirl.create(:snippet, lang: lang)

      expect(assigns(:snippets)).to eq([snippet])
    end

  end

  context "#new" do

    before :each do
      get :new
    end

    it "Should redirect, when not authenticated" do
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return 200 response, when authenticated", :auth => true do
      expect(session[:user_id]).not_to be_nil
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return new template", :auth => true do
      expect(response).to render_template("new")
    end

  end

  context "#create" do

    before :all do
      @attr = { :snippet => "new snippet", :description => "changed value" }
    end

    before :each do
      lang = FactoryGirl.build(:lang)
      @snippet = FactoryGirl.build(:snippet, lang: lang)

      put :create, :id => @snippet.id, :snippet => @attr
    end

    it "Should redirect, when not authenticated" do
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return 200 response, when authenticated", :auth => true do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

  end

  context "#edit"  do

    before :each do
      lang = FactoryGirl.create(:lang)
      @snippet = FactoryGirl.create(:snippet, lang: lang)

      get :edit, :id => @snippet.id
    end

    it "Should redirect, when not authenticated" do
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return 200 response, when authenticated", :auth => true do
      expect(session[:user_id]).not_to be_nil
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return edit template", :auth => true do
      expect(response).to render_template("edit")
    end

  end

  context "#update" do

    before :all do
      @attr = { :snippet => "new snippet", :description => "changed value" }
    end

    before :each do
      lang = FactoryGirl.create(:lang)
      @snippet = FactoryGirl.create(:snippet, lang: lang)

      put :update, :id => @snippet.id, :snippet => @attr
    end

    it "Should redirect, when not authenticated" do
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "Should update snippet when authenticated", :auth => true do
      @snippet.reload
      @snippet.description.should eq("changed value")
    end

    it "Should redirect to edited snippet when update succesfully", :auth => true do
      url = '/snippets/' + @snippet.id.to_s
      response.should redirect_to url;
    end

  end

  context "#destroy" do

    before :each do
      @snippet = FactoryGirl.create(:snippet)

      unless example.metadata[:skip_before]
        get :destroy, :id => @snippet.id
      end
    end

    it "Should redirect, when not authenticated" do
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

    it "should return redirect to snippets_url, when authenticated", :auth => true do
      expect(session[:user_id]).not_to be_nil
      response.should redirect_to snippets_url
    end

    it "Should remove snippet, when authenticated", :auth => true, :skip_before => true do
      count = Snippet.count

      get :destroy, :id => @snippet.id

      expect(Snippet.count).to eq(count-1)
    end

  end

end