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
  has_many :holiday_exceptions

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

  def find_dates_to_print(proj_report_start_date = nil, proj_report_end_date = nil)
    if proj_report_start_date.nil?
      start_day = Time.now.beginning_of_week
    else
      start_day = Date.parse(proj_report_start_date)
    end
    
    if proj_report_end_date.nil?
      last_day = start_day.end_of_week
    else
      last_day = Date.parse(proj_report_end_date).end_of_day
    end
    dates_array = []
    this_day = start_day
    while this_day < last_day
      dates_array << this_day.strftime('%m/%d')
      this_day = this_day.tomorrow
      
    end
    logger.debug "DATE ARRAY FOR USER: #{dates_array}"
    return dates_array
  end


  def build_project_hash(user,user_report_date_array, user_projects,start_date, end_date)
    # hash_user_report_data = Hash.new
    # project_ids = user_projects
    # project_ids.each do |p|
    #   time_entries = TimeEntry.where(user_id: user, project_id: p, date_of_activity: start_date..end_date).order(:date_of_activity)
    #   logger.debug ("Project is: #{p.name}")
    #   project_time_hash = Hash.new
    #   total_hours = 0
    #   daily_hours = 0
    #   time_entries.each do |t|
    #     if !project_time_hash[t.date_of_activity.strftime('%m/%d')].blank?
    #       if project_time_hash[t.date_of_activity.strftime('%m/%d')][:hours].blank?
    #         daily_hours = t.hours if !t.hours.blank?
    #         daily_hours = 0 if t.hours.blank?
    #       else
    #         daily_hours = project_time_hash[t.date_of_activity.strftime('%m/%d')][:hours] + t.hours if !t.hours.blank?
    #         daily_hours = project_time_hash[t.date_of_activity.strftime('%m/%d')][:hours] if t.hours.blank?
    #       end
    #     else
    #       daily_hours = !t.hours.blank? ? t.hours : 0
    #     end
    #     total_hours = total_hours + t.hours if !t.hours.blank?
    #     project_time_hash[t.date_of_activity.strftime('%m/%d')] = { id: t.id, hours: daily_hours, activity_log: t.activity_log }
    #   end

    #   proj = Project.find(p)
    #   hash_user_report_data[p] = { daily_hash: project_time_hash, total_hours: total_hours }
    # end
    # logger.debug "build_project_hash - hash_user_report_data is #{hash_user_report_data.inspect}"
    # return hash_user_report_data
  end
  
end
