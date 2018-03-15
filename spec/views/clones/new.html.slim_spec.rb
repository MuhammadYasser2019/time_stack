require 'rails_helper'

RSpec.describe "clones/new", type: :view do
  before(:each) do
    assign(:clone, Clone.new())
  end

  it "renders new clone form" do
    render

    assert_select "form[action=?][method=?]", clones_path, "post" do
    end
  end
end
