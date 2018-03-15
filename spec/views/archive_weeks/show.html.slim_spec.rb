require 'rails_helper'

RSpec.describe "archive_weeks/show", type: :view do
  before(:each) do
    @archive_week = assign(:archive_week, ArchiveWeek.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
