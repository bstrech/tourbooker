require 'spec_helper'

describe "Users" do
  describe "GET /users" do
    it "it should redirect" do
      get users_path
      response.status.should be(301)
    end
  end
end
