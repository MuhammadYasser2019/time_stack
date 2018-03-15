require 'rails_helper'

RSpec.describe "clones/show", type: :view do
  before(:each) do
    @clone = assign(:clone, Clone.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
