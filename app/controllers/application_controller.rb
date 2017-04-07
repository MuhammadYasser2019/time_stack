class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CanCan::ControllerAdditions
  
  before_action :authenticate_user!, :set_mailer_host
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to "/permission_denied", :alert => exception.message
  end

  protected

  def configure_permitted_parameters
    #Uncomment the below line if you are using devise version less than 4
    # devise_parameter_sanitizer.for(:accept_invitation).concat([:name])

    # The Parameter Sanitizer API has changed for Devise 4,please comment this line if you are using lower version of devise
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:name])
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :project_id, :invited_by_id])
  end

  private

  def set_mailer_host
    # ActionMailer::Base.default_url_options[:host] = "http://192.168.239.178:3000/users/sign_up"
  end

  def after_invite_path_for(resource)
    projects_path
  end
end

