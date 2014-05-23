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

    it "should return 200 response code" do
      expect(response).to be_success
      expect(response.status).to eq(200)
    end

    it "should return index template" do
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

    context "When not authenticated" do
      it "should redirect" do
        response.should redirect_to(:controller => 'snippets', :action => 'index')
      end
    end

    context "When authenticated" do
      it "should return 200 response", :auth => true do
        expect(session[:user_id]).not_to be_nil
        expect(response).to be_success
        expect(response.status).to eq(200)
      end

      it "Should return new template", :auth => true do
        expect(response).to render_template("new")
      end
    end
  end

  context "#create" do
    before :each do
      lang = FactoryGirl.create(:lang)
      @snippet = FactoryGirl.create(:snippet, lang: lang)
    end

    context "With valid attributes" do
      before :all do
        @newSnippet = FactoryGirl.build(:snippet)
      end

      before :each do
        put :create, :id => @snippet.id, :snippet => FactoryGirl.attributes_for(:snippet)
      end

      context "When not authenticated" do
        it "should redirect to snippets#index" do
          response.should redirect_to(:controller => 'snippets', :action => 'index')
        end
      end

      context "When authenticated" do
        it "should return 200 response, when authenticated", :auth => true do
          expect(response).to be_success
          expect(response.status).to eq(200)
        end
      end
    end

    context "With invalid attributes" do
      before :all do
        @invalidSnippet = FactoryGirl.build(:invalid_snippet)
      end

      before :each do
        unless example.metadata[:skip_before]
          put :create, :id => @snippet.id, :snippet => FactoryGirl.attributes_for(:invalid_snippet)
        end
      end

      it "should not save the new snippet", :auth => true, :skip_before => true do
        expect { put :create, :id => @snippet.id, :snippet => FactoryGirl.attributes_for(:invalid_snippet) }.to_not change(Snippet, :count)
      end

      it "should render new method, again", :auth => true do
        response.should render_template :new
      end
    end
  end

  context "#edit"  do
    context "With valid attributes" do
      before :each do
        lang = FactoryGirl.create(:lang)
        @snippet = FactoryGirl.create(:snippet, lang: lang)

        get :edit, :id => @snippet.id
      end

      context "When not authenticated" do
        it "should redirect to snippets#index" do
          response.should redirect_to(:controller => 'snippets', :action => 'index')
        end
      end

      context "When authenticated" do
        it "should return 200 response", :auth => true do
          expect(session[:user_id]).not_to be_nil
          expect(response).to be_success
          expect(response.status).to eq(200)
        end

        it "Should return edit template", :auth => true do
          expect(response).to render_template("edit")
        end
      end
    end
  end

  context "#update" do
    before :each do
      lang = FactoryGirl.create(:lang)
      @snippet = FactoryGirl.create(:snippet, lang: lang)
    end

    context "With valid attributes" do
      before :all do
        @updatedSnippet = FactoryGirl.build(:snippet_to_update)
      end

      before :each do
        put :update, :id => @snippet.id, :snippet => FactoryGirl.attributes_for(:snippet_to_update)
      end

      context "when not authenticated" do

        it "should redirect to snippets#index" do
          response.should redirect_to(:controller => 'snippets', :action => 'index')
        end
      end

      context "when authenticated" do

        it "should update snippet", :auth => true do
          @snippet.reload
          @snippet.snippet.should eq @updatedSnippet.snippet
          @snippet.description.should eq @updatedSnippet.description
        end

        it "should redirect to edited snippet when update succesfully", :auth => true do
          url = '/snippets/' + @snippet.id.to_s
          response.should redirect_to url;
        end
      end
    end

    context "with invalid attributes" do
      before :all do
        @invalidSnippet = FactoryGirl.build(:invalid_snippet)
      end

      before :each do
        put :update, :id => @snippet.id, :snippet => FactoryGirl.attributes_for(:invalid_snippet)
      end

      it "should not update snippet attributes", :auth => true do
        @snippet.reload
        @snippet.snippet.should_not eq @invalidSnippet.snippet
        @snippet.description.should_not eq @invalidSnippet.description
      end

      it "should render edit method, again", :auth => true do
        response.should render_template :edit
      end
    end

  end

  context "#destroy" do
    before :each do
      @snippet = FactoryGirl.create(:snippet)

      unless example.metadata[:skip_before]
        get :destroy, :id => @snippet.id
      end
    end

    context "When not authenticated" do
      it "should redirect to snippets#index" do
        response.should redirect_to(:controller => 'snippets', :action => 'index')
      end
    end

    context "When authenticated" do
      it "should return redirect to snippets_url", :auth => true do
        expect(session[:user_id]).not_to be_nil
        response.should redirect_to snippets_url
      end

      it "should remove snippet", :auth => true do
        expect { Snippet.find(@snippet) }.to raise_error ActiveRecord::RecordNotFound
      end

      it "should decrease snippet count by 1", :auth => true, :skip_before => true do
        expect { post :destroy, :id => @snippet.id }.to change(Snippet, :count).by(-1)
      end
    end
  end
end
