class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include CanCan::ControllerAdditions
  
  before_filter :authenticate_user!, :set_mailer_host
  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:accept_invitation).concat([:name])
  end

  private

  def set_mailer_host
    ActionMailer::Base.default_url_options[:host] = "http://192.168.239.178:3000/users/sign_up"
  end

  def after_invite_path_for(resource)
    projects_path
  end
end

