class FeaturesController < ApplicationController
  skip_before_action :authenticate_user!
  def show
  	@feature = Feature.find params[:id]
  end
end