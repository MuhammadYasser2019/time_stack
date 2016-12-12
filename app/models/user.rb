class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :password , presence: true, if: :not_google_account?
  # validates :password_confirmation , presence: true, if: :not_google_account?


  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  has_many :projects_users
  has_many :projects , :through => :projects_users
  has_many :roles, :through => :user_roles
  has_many :user_roles


  def not_google_account?
    logger.debug("################not google account")
    if google_account == "1"
      logger.debug("##################in the if of no google account")
      return false
    else
      logger.debug("##################in the else of no google account")
      return true
    end
  end

  def self.from_omniauth(access_token)
    data = access_token.info
    user = User.where(:email => data["email"]).first

    # Uncomment the section below if you want users to be created if they don't exist
    # unless user
    #     user = User.create(name: data["name"],
    #        email: data["email"],
    #        password: Devise.friendly_token[0,20]
    #     )
    # end
    user
  end
end
