module UserHelper
  def authenticate_user_from_token
    user_email = params[:email].presence
    user       = user_email && User.find_by(email: user_email)
    user_token = request.headers["Authorization"].split(" ").last
 
    # Notice how we use Devise.secure_compare to compare the token
    # in the database with the token given in the params, mitigating
    # timing attacks.
    if user && Devise.secure_compare(user.authentication_token, user_token)
      # sign_in user, store: false
      user
    else
      # render nothing: true, status: :unauthorized and return
      # return false
      render :json => {status: :unauthorized ,message: "You have to login"}
    end
  end

  def new_messages 
    UserNotification.where(:user_id => current_user.id, :seen => false).count 
  end

end
