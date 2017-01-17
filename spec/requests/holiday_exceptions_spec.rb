require 'rails_helper'

RSpec.describe "HolidayExceptions", type: :request do
  describe "GET /holiday_exceptions" do
    it "works! (now write some real specs)" do
      get holiday_exceptions_path
      expect(response).to have_http_status(200)
    end
  end
end
