require 'rails_helper'

RSpec.describe "clones/edit", type: :view do
  before(:each) do
    @clone = assign(:clone, Clone.create!())
  end

  it "renders the edit clone form" do
    render

    assert_select "form[action=?][method=?]", clone_path(@clone), "post" do
    end
  end
end
