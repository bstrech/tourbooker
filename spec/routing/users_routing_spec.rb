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
    it "routes to #resend_authorization" do
      get("/users/1/resend_authorization").should route_to("users#resend_authorization", :id=>"1")
    end
    it "routes to #authorize" do
      get("/users/1/authorize").should route_to("users#authorize", :id=>"1")
    end
  end
end
