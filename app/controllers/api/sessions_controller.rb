module Api
  class SessionsController < ActionController::
      #include UsersHelper

    def create
      user = User.find_by(email: params[:email])

      if user&.valid_password?(params[:password])
        render json: user.as_json(only: [:email, :authentication_token]),status: :created
      else
        render :json => {status: :unauthorized ,message: "The email or password was incorrect. Please try again"}
      end


    end

    def destroy
      logger.debug("In the session destroy method")
    end

  end
end