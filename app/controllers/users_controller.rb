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
    @holidays = Holiday.where(global: true)
    @customers = Customer.where(user_id: nil)
    @invited_users = User.where("invited_by_id = ?", current_user.id)
  end
  
  def new
    @user = User.find(params[:id])
  end
  
  def create
    logger.debug "PARAMS: #{params[:users]}"
    logger.debug "id is #{params[:id]}"
    if params[:id] == nil
      params[:user].permit!.to_h.each do |p|
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
  
  def proxies
    @user = User.find(params[:id])
    @proxies = Project.where(proxy: @user.id)
  end
  
  def proxy_users
    @user = User.find(params[:id])
    @proxy = Project.find(params[:proxy_id])
    @proxy_users = @proxy.users
  end
  
  def invite_customer
    @user = User.invite!(email: params[:email], invited_by_id: params[:invited_by_id])
    Customer.find(params[:customer_id]).update(user_id: @user.id)
    redirect_to admin_path
  end
  
  private
  
    def user_params
      params.require(:user).permit(:id, :first_name, :last_name, :email, :password, :password_confirmation, :user, :cm, :pm, :admin, :proxy, :invited_by_id)
    end
  
end