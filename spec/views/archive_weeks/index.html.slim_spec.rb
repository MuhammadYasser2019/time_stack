require 'rails_helper'

RSpec.describe "archive_weeks/index", type: :view do
  before(:each) do
    assign(:archive_weeks, [
      ArchiveWeek.create!(),
      ArchiveWeek.create!()
    ])
  end

  it "renders a list of archive_weeks" do
    render
  end
end
