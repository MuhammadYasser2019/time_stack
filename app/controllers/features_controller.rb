class FeaturesController < ApplicationController

  skip_before_action :authenticate_user! ,except: :faq
   
   def faq
    if  user_signed_in? && current_user.pm?
          feature_type = "FAQ for ProjectManager"
      elsif user_signed_in? && current_user.cm? 
          feature_type = "FAQ for CustomerManager"
         else 
         feature_type = "FAQ for User"
   end 
    @faq = Feature.where(feature_type)
  end
  

  def show
  	@feature = Feature.find params[:id]
  end
  
  def update_front_page_content
    @feature = Feature.find params[:feature_id]
    @feature.feature_data = params[:feature_content][:content]
    @feature.save
    respond_to do |format|
      format.js
    end
  end

  def available_data
    logger.debug "available_data - starting to process, params passed  are #{params[:id]}"
    feature_id  = params[:id]
    
    @feature = Feature.where(id: feature_id)
    logger.debug "available_feature - leaving  @feature is #{@feature}"

  end
end