class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!
  def home

  end


  def privacy

  end

  def terms_of_service

  end

  def contact_form_mail
    respond_to do |format|
      if FeedbackMailer.contact_form_email(params[:email], params[:name], params[:message]).deliver
        format.html { flash[:notice] = "Email Sent!" }
        format.js { redirect_to root_path }
      else
        format.html { flash[:notice] = "Something Went Wrong, Our Developers Have Been Notified." }
        format.js { redirect_to root_path }
      end
    end
  end

end 

