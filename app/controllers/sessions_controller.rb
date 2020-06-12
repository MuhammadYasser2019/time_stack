class SessionsController < Devise::SessionsController
  after_action :check_password_expiration
  
    def create
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_flashing_format?
        sign_in(resource_name, resource)
        session[:token] = User.generate_jwt_token(resource.id)
        yield resource if block_given?
        respond_with resource, :location => after_sign_in_path_for(resource) do |format|
          format.json {render :json => resource } # this code will get executed for json request
        end
    end

    def destroy
      session[:token] = ""
      super
    end

    private
    def check_password_expiration
      if current_user.present?
        send_email_date = current_user.password_changed_at + 1.minutes
         date = Time.now.to_datetime 
        if date.to_datetime >= send_email_date.to_datetime
            @host = request.host
            @url = request.url
            @user = current_user
            #@user.generate_reset_password_token!
            raw, enc = Devise.token_generator.generate(User, :reset_password_token)
            PasswordExpiration.mail_for_expiration_to_user(current_user,@host,@url,raw).deliver
             current_user.reset_password_token = raw
             current_user.save
        end
      end
    end
  end