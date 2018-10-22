require 'rails_helper'

RSpec.describe "Auths", type: :request do
  describe "GET /auths" do
    it "works! (now write some real specs)" do
      get auths_path
      expect(response).to have_http_status(200)
    end
  end
end
