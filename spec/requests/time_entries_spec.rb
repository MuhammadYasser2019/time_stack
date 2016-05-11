require 'rails_helper'

RSpec.describe "TimeEntries", type: :request do
  describe "GET /time_entries" do
    it "works! (now write some real specs)" do
      get time_entries_path
      expect(response).to have_http_status(200)
    end
  end
end
