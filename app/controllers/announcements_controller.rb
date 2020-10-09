class AnnouncementsController < ApplicationController
  skip_before_action :authenticate_user!



  def get_announcement
        @announcements = Announcement.all
    end

  def create_announcement

    @announcement = Announcement.new
    @announcement.announcement_type = params[:announcement_type]
    @announcement.announcement_text = params[:text_content]
    @announcement.start_date = params[:start_date]
    @announcement.end_date = params[:end_date]
    @announcement.active = true
    @announcement.save
    respond_to do |format|
      format.js
    end
  end

  
end