require 'spec_helper'

describe WelcomeController do
  it "index action should render index template" do
    get :index
    response.should render_template(:index)
  end
end
