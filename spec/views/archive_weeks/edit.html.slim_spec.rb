require 'rails_helper'

RSpec.describe "archive_weeks/edit", type: :view do
  before(:each) do
    @archive_week = assign(:archive_week, ArchiveWeek.create!())
  end

  it "renders the edit archive_week form" do
    render

    assert_select "form[action=?][method=?]", archive_week_path(@archive_week), "post" do
    end
  end
end
