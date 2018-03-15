require 'rails_helper'

RSpec.describe "ArchiveWeeks", type: :request do
  describe "GET /archive_weeks" do
    it "works! (now write some real specs)" do
      get archive_weeks_path
      expect(response).to have_http_status(200)
    end
  end
end
