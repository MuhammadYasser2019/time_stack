class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  # validates :password , presence: true, if: :not_google_account?
  # validates :password_confirmation , presence: true, if: :not_google_account?

  mount_uploader :image, ImageUploader
  ## Token Authenticatable
  acts_as_token_authenticatable


  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable,
         :omniauthable, :omniauth_providers => [:google_oauth2]
  devise :timeoutable, :timeout_in => 30.minutes
  has_many :projects_users
  has_many :projects , :through => :projects_users
  has_many :roles, :through => :user_roles
  has_many :user_roles
  has_many :holiday_exceptions
  has_many :vacation_requests
  has_many :user_notifications
  has_many :project_shifts, through: :projects_users
  has_many :user_recommendations
  has_many :user_disciplinary
  has_many :user_inventory_and_equipments
  has_many :user_devices

  validates :emergency_contact, format: { with: /\A\d+\z/, message: "Please enter 10 digit minimum contact number." }

  def childs
    self.parent_user_id.present? ? nil : User.where(id: self.parent_user_id)

  end

  def parent
    self.parent_user_id.present? ? User.where(id: self.parent_user_id).first : nil
  end

  def name
    if self.first_name.present? && self.last_name.present?
      return "#{self.first_name}" + " #{ self.last_name}"
    else
      self.email
    end
  end

  def self.approved_week(user,start_date)
    logger.debug(" LOOK LOOK ")
    user = User.where(:email => params[:email])
    approved_week = Week.where(:status_id => 3, :start_date => params[:start_date])  
  end 

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

  def self.send_timesheet_notification
    last_weeks = Week.where("start_date >=? ", Time.now.utc.beginning_of_day-7.days)
    last_weeks.each do |w|
        if w.status_id != 2 || w.status_id != 3
            user = User.find w.user_id
            
            projects = ProjectsUser.where(user_id: user.id).pluck(:project_id)
            flag_array =  Array.new
            projects.each do |p|
              project = Project.find(p)
              flag_array.push(project.deactivate_notifications)
            end
  
            if flag_array.include?(false) 
              logger.debug("***************Sending the Notifications to : #{user.inspect}")
              if UserNotification.where("week_id =?", w.id).blank?
                TimesheetNotificationMailer.mail_to_user(w,user).deliver_now
                User.push_notification(user, w.id)
              end
            end
      end
    end
  end

  def self.push_notification(user, week_id)
    body ="<html>You have not filled your last week timesheet.</html>"
    UserNotification.create(user_id: user.id, 
                            notification_type: "Timesheet Reminder",
                            body: body,
                            week_id: week_id,
                            count: 1, 
                            seen: false)
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
    logger.debug "DATE ARRAAAAAAAAAAAAAAAAY: #{dates_array}"
    return dates_array
  end

  def full_date_array(proj_report_start_date = nil, proj_report_end_date = nil)
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
      dates_array << this_day
      this_day = this_day.tomorrow

    end
    logger.debug "DATE ARRAAAAAAAAAAAAAAAAY: #{dates_array}"
    return dates_array
  end

  def days_of_week(proj_report_start_date = nil, proj_report_end_date = nil)
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
      dates_array << this_day.strftime('%a')
      this_day = this_day.tomorrow

    end
    logger.debug "DATE ARRAAAAAAAAAAAAAAAAY: #{dates_array}"
    return dates_array
  end

  def user_times(start_date, end_date, user)
    hash_report_data = Hash.new
    customers = user.projects.pluck(:customer_id).uniq
    customers.each do |c|
      projects = Project.where(customer_id: c).pluck(:id)
      time_entries = TimeEntry.where(user_id: user.id, project_id: projects, date_of_activity: start_date..end_date).order(:date_of_activity)
      employee_time_hash = Hash.new
      total_hours = 0
      daily_hours = 0
      time_entries.each do |t|
          if !employee_time_hash[t.date_of_activity.strftime('%m/%d')].blank?
            if employee_time_hash[t.date_of_activity.strftime('%m/%d')][:hours].blank?
              daily_hours = t.hours if !t.hours.blank?
              daily_hours = 0 if t.hours.blank?
            else
              daily_hours = employee_time_hash[t.date_of_activity.strftime('%m/%d')][:hours] + t.hours if !t.hours.blank?
              daily_hours = employee_time_hash[t.date_of_activity.strftime('%m/%d')][:hours] if t.hours.blank?
            end
          else
            daily_hours = !t.hours.blank? ? t.hours : 0
          end

          total_hours = total_hours + t.hours if !t.hours.blank?
          employee_time_hash[t.date_of_activity.strftime('%m/%d')] = { id: t.id, hours: daily_hours, activity_log: t.activity_log }
      end
      u = User.find(c)
      hash_report_data[c] = { daily_hash: employee_time_hash, total_hours: total_hours }
      logger.debug "build_consultant_hash - hash_report_data is #{hash_report_data.inspect}"
     end
    return hash_report_data
  end

  def find_week_id(start_date, end_date,user)
    week_array = []
      t = TimeEntry.where(user_id: user.id, date_of_activity: start_date..end_date)
      logger.debug("THE T ARE : #{t} and the user is #{user}")
      t.each do |tw|
        week_array << tw.week_id
      end

    week_with_attachment_array = []
    week_array.uniq.each do |w|
      week_with_attachment_array << Week.find(w) if UploadTimesheet.find_by_week_id(w).present?
    end
    return week_with_attachment_array

  end

  def active_for_authentication?
    #remember to call the super
    #then put our own check to determine "active" state using 
    #our own "is_active" column
    super and self.is_active?
  end

  def self.generate_jwt_token(user_id , expiry_time = 1.hours.from_now.to_i)
    payload = {'user_id'=> user_id, 'exp'=> expiry_time};
    JWT.encode(payload, jwt_secret)
  end

  def self.decode_jwt_token(authToken)
    token = authToken.present? ? authToken.split(' ')[1]: ''
    HashWithIndifferentAccess.new(JWT.decode(token, jwt_secret)[0])
  rescue
    nil
  end

  private

  def self.jwt_secret
    YAML.load(File.read('config/jwt-secret.yml'))
  end
end
