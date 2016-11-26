class Project < ActiveRecord::Base
  belongs_to :customer
  has_many :tasks
  has_many :time_entries
  has_many :projects_users
  has_many :users , :through => :projects_users
  
  def find_dates_to_print(proj_report_start_date = nil, proj_report_end_date = nil)
    if proj_report_start_date.nil?
      start_day = Time.now.beginning_of_week
    else
      start_day = Date.parse(proj_report_start_date)
    end
    
    if proj_report_end_date.nil?
      last_day = start_day.end_of_week
    else
      last_day = Date.parse(proj_report_end_date)
    end
    dates_array = []
    this_day = start_day
    while this_day < last_day
      dates_array << this_day.strftime('%m/%d')
      this_day = this_day.tomorrow
      
    end
    
    return dates_array
  end
  
  def build_consultant_hash(project_id, dates_array, start_date, end_date)
    hash_report_data = Hash.new
    consultant_ids = Project.find(project_id).users.collect {|c| c.id}.flatten
    consultant_ids.each do |c|
      time_entries = TimeEntry.where(user_id: c, project_id: project_id, date_of_activity: start_date..end_date).order(:date_of_activity)
      logger.debug "consultant is #{c}"
      employee_time_hash = Hash.new
      total_hours = 0
      time_entries.each do |t|
        total_hours = total_hours + t.hours if !t.hours.blank?
        employee_time_hash[t.date_of_activity.strftime('%m/%d')] = { id: t.id, hours: t.hours, activity_log: t.activity_log }
      end
      u = User.find(c)
      hash_report_data[c] = { daily_hash: employee_time_hash, total_hours: total_hours }
    end
    return hash_report_data
  end
  
  def self.convert_date_format(date_str)
    if date_str.nil?
      date_str = Time.now.strftime('%m-%d-%Y')
    end
    date_arr = date_str.split("-") 
    return date_arr[2] + "/" + date_arr[0] + "/" + date_arr[1]
  end
end
