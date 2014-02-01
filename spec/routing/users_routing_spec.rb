require "spec_helper"

describe UsersController do
  describe "routing" do
    it "routes to #new" do
      get("/users/new").should route_to("users#new")
    end
    it "routes to #create" do
      post("/users").should route_to("users#create")
    end
    it "routes to #create_success" do
      get("/users/1/create_success").should route_to("users#create_success", :id=>"1")
    end
  end
end
