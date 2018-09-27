require "rails_helper"

RSpec.describe SubtasksController, type: :routing do
  describe "routing" do
    it "routes to #index" do
      expect(:get => "/subtasks").to route_to("subtasks#index")
    end

    it "routes to #show" do
      expect(:get => "/subtasks/1").to route_to("subtasks#show", :id => "1")
    end


    it "routes to #create" do
      expect(:post => "/subtasks").to route_to("subtasks#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/subtasks/1").to route_to("subtasks#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/subtasks/1").to route_to("subtasks#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/subtasks/1").to route_to("subtasks#destroy", :id => "1")
    end
  end
end
