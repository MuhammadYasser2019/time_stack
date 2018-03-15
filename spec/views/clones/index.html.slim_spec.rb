require 'rails_helper'

RSpec.describe "clones/index", type: :view do
  before(:each) do
    assign(:clones, [
      Clone.create!(),
      Clone.create!()
    ])
  end

  it "renders a list of clones" do
    render
  end
end
