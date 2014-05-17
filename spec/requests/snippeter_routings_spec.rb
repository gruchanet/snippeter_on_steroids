require 'spec_helper'

describe "Snippeter" do

  describe "GET /" do
    it "sends response with status code 200" do
      get root_path
      response.status.should be(200)
    end
  end

end
