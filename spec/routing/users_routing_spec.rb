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
    it "routes to #resend_activation" do
      get("/users/1/resend_activation").should route_to("users#resend_activation", :id=>"1")
    end
    it "routes to #activate" do
      get("/users/1/activate").should route_to("users#activate", :id=>"1")
    end
    it "routes to #save_activation" do
      put("/users/1/save_activation").should route_to("users#save_activation", :id=>"1")
    end
    it "routes to #register" do
      get("/users/1/register").should route_to("users#register", :id=>"1")
    end
    it "routes to #save_registration" do
      put("/users/1/save_registration").should route_to("users#save_registration", :id=>"1")
    end
    it "routes to #registration_success" do
      get("/users/1/registration_success").should route_to("users#registration_success", :id=>"1")
    end
    it "routes to #rate" do
      get("/users/1/rate").should route_to("users#rate", :id=>"1")
    end
    it "routes to #save_rating" do
      put("/users/1/save_rating").should route_to("users#save_rating", :id=>"1")
    end
    it "routes to #rating_success" do
      get("/users/1/rating_success").should route_to("users#rating_success", :id=>"1")
    end
  end
end
