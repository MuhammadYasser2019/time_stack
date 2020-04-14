module Api
    class NotificationsController < BaseController
        def save_device_info
            begin
                @user_id = params[:userID]
                @device_id = params[:deviceID]

                @user_device = UserDevice.where(:device_id => @device_id, :user_id => @user_id).first

                if @user_device.nil?
                    @user_device = UserDevice.new
                    @user_device.user_id = @user_id
                    @user_device.device_id = @device_id
                    @user_device.user_token = params[:userToken]
                    @user_device.platform = params[:platform]
                    @user_device.save
                else
                    @user_device.user_token = params[:userToken]
                    @user_device.save
                end
              
                UserDevice.where_not(:user_id=> @user_id).update_all(user_token: nil)
    
                render json: format_response_json({
                    status: true
                })
            rescue => exception
                render json: format_response_json({
					message: 'Failed to save push token!',
					status: false
				})
            end
        end

        def remove_device_info
           begin
                @user_id = params[:userID]
                @device_id = params[:deviceID]
                
                @user_device = UserDevice.where(:device_id => @device_id, :user_id => @user_id).first
                
                if @user_device.nil?
                    @user_device.user_token = nil
                    @user_device.save
                end

                render json: format_response_json({
                    message: 'Successfully removed push token!',
                    status: true
                })
           rescue => exception
                render json: format_response_json({
                    message: 'Failed to remove push token!',
                    status: false
                })
           end
        end
    end
end