require "spec_helper"

describe UsersController do
  describe "routing" do
    it "routes to #new" do
      get("/users/new").should route_to("users#new")
    end
    it "routes to #create" do
      post("/users").should route_to("users#create")
    end

  end
end
