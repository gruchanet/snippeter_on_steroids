require 'spec_helper'

describe "Snippeter" do

  context "GET" do
    it "/ sends response with status code 200" do
      get root_path
      response.status.should be(200)
    end
    it "/about sends response with status code 200" do
      get about_path
      response.status.should be(200)
    end
    it "/snippets/new sends response with status code 302" do
      get '/snippets/new'
      response.status.should be(302)
    end

  end

end
