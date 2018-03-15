require "rails_helper"

RSpec.describe ClonesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/clones").to route_to("clones#index")
    end

    it "routes to #new" do
      expect(:get => "/clones/new").to route_to("clones#new")
    end

    it "routes to #show" do
      expect(:get => "/clones/1").to route_to("clones#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/clones/1/edit").to route_to("clones#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/clones").to route_to("clones#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/clones/1").to route_to("clones#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/clones/1").to route_to("clones#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/clones/1").to route_to("clones#destroy", :id => "1")
    end

  end
end
