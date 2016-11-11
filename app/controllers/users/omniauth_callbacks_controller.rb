class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def google_oauth2
    # You need to implement the method below in your model (e.g. app/models/user.rb)
    @user = User.from_omniauth(request.env["omniauth.auth"].except("extra"))

    logger.debug("@11111111111111111user #{@user} ")
    if !@user.nil?
      logger.debug("############inside if of nil check #{@user.persisted?}")
      if @user.persisted?
        logger.debug("############inside if of perseted chcek")
        flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :kind => "Google"
        sign_in_and_redirect @user, :event => :authentication
      else
        logger.debug("############inside else of perseted chcek")
        session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
        redirect_to users_sign_in_path
      end
    else
      logger.debug("############inside else of nil check")
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to users_sign_in_path
    end

  end
end