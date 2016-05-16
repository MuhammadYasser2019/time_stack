module WeeksHelper
  def find_day(date_str)
    logger.debug "weeks_helper - find_day - param is #{date_str}"
    
    return date_str
  end
  def find_status(user_week_status)
    if user_week_status.nil?
      return "NEW"
    end
    stat =  Status.find(user_week_status.status_id).status
    
    if stat.nil?
      return "NEW"
    else
      return stat
    end
  end
  
end
