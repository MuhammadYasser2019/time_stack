class AnnouncementsController < ApplicationController
  skip_before_action :authenticate_user!



  def get_announcement        
        @announcement = Announcement.where("active = true").last
        @announcement.update_column(:seen, true)

  end

  def update_announcement        
        @announcement = Announcement.find_by_id(params[:announcement_id]) 
        if @announcement.present?
            @announcement.update_column(:seen, true)
        end

  end
  
  def edit_announcement        
        @announcement = Announcement.find_by_id(params[:announcement_id])
  end
  
   def destroy    
        @announcement = Announcement.find_by_id(params[:id])
        if @announcement.present?
            @announcement.destroy
        end
      redirect_to admin_path

    end

  def create_announcement    
    @announcement = Announcement.new
    @announcement.announcement_type = params[:announcement_type]
    @announcement.announcement_text = params[:text_content][:content]    
    @announcement.active =params[:is_active]    
    #@announcement.end_date = params[:end_date]
    #@announcement.active = true  
    @announcement.seen = false
    @announcement.save
    respond_to do |format|
      format.js
    end
  end

  
end