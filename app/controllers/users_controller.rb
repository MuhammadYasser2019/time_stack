class UsersController < ApplicationController
  load_and_authorize_resource
  def user_account
    @user = current_user
  end
  
  def show
    @user = User.find(params[:id])
  end
  
  def admin
    @users = User.all
  end
  
  def new
    @user = User.find(params[:id])
  end
  
  def create
    logger.debug "PARAMS: #{params[:users]}"
    logger.debug "id is #{params[:id]}"
    if params[:id] == nil
      params[:user].each do |p|
        logger.debug "p is #{p}"
        User.find(p[0]).update(p[1].deep_symbolize_keys())
      end
    else
      @user = User.find(params[:id])
      @user.update_attributes(user_params)
    end
    redirect_to admin_path
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def index
    @users = User.all
  end
  
  def update
    logger.debug "PARAMS: #{params.inspect}"
    if params[:id] == nil
      params.each do |p|
        logger.debug "P is #{p}"
      end
    else
      @user = User.find(params[:id])
      @user.update_attributes(user_params)
    end
    redirect_to edit_user_path(@user)
  end
  
  private
  
    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation, :user, :cm, :pm, :admin)
    end
  
end