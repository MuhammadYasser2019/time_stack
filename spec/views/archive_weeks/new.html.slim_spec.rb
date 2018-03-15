require 'rails_helper'

RSpec.describe "archive_weeks/new", type: :view do
  before(:each) do
    assign(:archive_week, ArchiveWeek.new())
  end

  it "renders new archive_week form" do
    render

    assert_select "form[action=?][method=?]", archive_weeks_path, "post" do
    end
  end
end
