require 'spec_helper'

describe "Users" do
  describe "GET root" do
    it "it should redirect" do
      get "/"
      response.status.should be(200)
    end
  end
end
