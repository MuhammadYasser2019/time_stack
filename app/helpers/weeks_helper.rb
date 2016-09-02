module WeeksHelper
  def find_day(date_str)
    logger.debug "weeks_helper - find_day - param is #{date_str}"
    
    return date_str
  end
  def find_status(week)
    if week.nil?
      return "NEW"
    end
    stat =  Status.find(week.status_id).status
    
    if stat.nil?
      return "NEW"
    else
      return stat
    end
  end
  
  def current_week_available(current_user)
    #logger.debug "weeks_helper - current_week_available - See if current user #{current_user.email}, has time entered for this week."
    current_week = Week.where(user_id: current_user, start_date: Date.today.beginning_of_week.strftime('%Y-%m-%d'))
  end
  def get_project_id(project_id)
    if project_id.blank? 
      return nil
    else
      return project_id
    end
  end
end
