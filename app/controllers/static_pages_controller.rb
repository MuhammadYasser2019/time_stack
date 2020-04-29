class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def home

  end


  def privacy

  end

  def terms_of_service

  end

end 

