class InvitationsController < Devise::InvitationsController

  def create
    @project_id = params[:user][:project_id]
    logger.debug("######project id #{@project_id} ------ #{params[:user]}")
    super
    logger.debug("####after create super")
  end

  def edit
    logger.debug("##########################invitation edit method #{params.inspect}")
    # @project_id = params
  end

  def update
    user_params = params[:user]
    user = User.find_by_email(user_params[:email])
    logger.debug("######create accout #{params.inspect}")
      user.google_account = user_params[:google_account]
      user.first_name = user_params[:first_name]
      user.last_name = user_params[:last_name]
      user.save!
    super
  end

end