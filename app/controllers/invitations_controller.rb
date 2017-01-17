class InvitationsController < Devise::InvitationsController

  #RESEND INVITE ###
  def resend_invite
    User.invite!({:email => params[:email]},current_user)
    redirect_to projects_path
  end
  
  def create
    logger.debug "HELLO NURSE"
    if params[:user][:customer_id]
      logger.debug "HELLO CUSTOMER ID"
    else
      super
    end
  end

  def update
    user_params = params[:user]
    logger.debug "IS THIS HAPPENING"
    user_google_account = user_params[:google_account]
    logger.debug("#####################33 user_google_account  #{user_google_account} ")
    user = User.find_by_email(user_params[:email])
    if user_google_account.to_i == 1
      user_data_save
      user.invitation_accepted_at = Time.zone.now.strftime("%Y-%m-%d %H:%M:%S")
      user.save!
      redirect_to user_google_oauth2_omniauth_authorize_path and return
    end
    logger.debug("######create accout #{params.inspect}")
    user_data_save
    super
  end

  def user_data_save
    user_params = params[:user]
    user_google_account = user_params[:google_account]
    logger.debug("#####################33 user_google_account  #{user_google_account} ")
    user = User.find_by_email(user_params[:email])
    user.google_account = user_params[:google_account]
    user.first_name = user_params[:first_name]
    user.last_name = user_params[:last_name]
    user.user = 1
    user.save!
    inviter = user.invited_by_id
    ApprovalMailer.invitation_accepted(inviter, user).deliver
  end

end