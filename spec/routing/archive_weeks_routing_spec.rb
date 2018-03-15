require "rails_helper"

RSpec.describe ArchiveWeeksController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/archive_weeks").to route_to("archive_weeks#index")
    end

    it "routes to #new" do
      expect(:get => "/archive_weeks/new").to route_to("archive_weeks#new")
    end

    it "routes to #show" do
      expect(:get => "/archive_weeks/1").to route_to("archive_weeks#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/archive_weeks/1/edit").to route_to("archive_weeks#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/archive_weeks").to route_to("archive_weeks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/archive_weeks/1").to route_to("archive_weeks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/archive_weeks/1").to route_to("archive_weeks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/archive_weeks/1").to route_to("archive_weeks#destroy", :id => "1")
    end

  end
end
