require 'rails_helper'

RSpec.describe "Subtasks", type: :request do
  describe "GET /subtasks" do
    it "works! (now write some real specs)" do
      get subtasks_path
      expect(response).to have_http_status(200)
    end
  end
end
