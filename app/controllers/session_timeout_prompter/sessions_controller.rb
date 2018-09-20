module SessionTimeoutPrompter
  class SessionsController < ActionController::Base

    def new
      sign_out current_user
      redirect_to new_user_session_path
    end

  end
end