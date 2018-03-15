require 'rails_helper'

RSpec.describe "Clones", type: :request do
  describe "GET /clones" do
    it "works! (now write some real specs)" do
      get clones_path
      expect(response).to have_http_status(200)
    end
  end
end
