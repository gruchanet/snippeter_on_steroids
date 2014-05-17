require 'spec_helper'

describe SnippetsController do

  describe "#index" do

    it "Should return 200 response code" do
      #sends get to index action
      get :index
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "Should return amount of snippets" do
      get :index
      expect(response).to render_template("index")
    end

    #it "assigns snippets" do
    #  lang    = Lang.create!
    #  snippet = Snippet.create snippet: '', lang_id: lang, description: ''
    #  snippet.save
    #  get :index
    #  expect(assigns(:snippets)).to eq([snippet])
    #end

  end

  describe "#new" do

    it "Should redirect, if not authenticated" do
      get :new
      response.should redirect_to(:controller => 'snippets', :action => 'index')
    end

  end

  describe "#edit"  do

    #before :each do
    #  @snippet = FactoryGirl.create(:snippet)
    #end
    #
    #  it "Should redirect, if not authenticated" do
    #  get :edit, :id => @gist.id
    #  response.should redirect_to(:controller => 'snippets', :action => 'index')
    #end

  end

  describe "#destroy" do

    #it "Should redirect, if not authenticated" do
    #  get :destroy
    #  response.should redirect_to(:controller => 'snippets', :action => 'index')
    #end

  end

end