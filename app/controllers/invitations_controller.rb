class InvitationsController < Devise::InvitationsController

  #RESEND INVITE ###
  def resend_invite
    User.invite!({:email => params[:email]},current_user)
    redirect_to projects_path
  end

  def update


    user_params = params[:user]
    user = User.find_by_email(user_params[:email])
    logger.debug("######create accout #{params.inspect}")
      user.google_account = user_params[:google_account]
      user.first_name = user_params[:first_name]
      user.last_name = user_params[:last_name]
      user.user = 1
      user.save!
    inviter = user.invited_by_id
    ApprovalMailer.invitation_accepted(inviter, user).deliver
    super
  end

end