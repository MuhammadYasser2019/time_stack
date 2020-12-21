module ProjectsHelper
  def consultant_name(fname, lname, email)
    consultant_name = email
    if fname.nil? || lname.nil?
  
    else
      consultant_name = "#{fname} #{lname}"
    end
    return consultant_name
  end

  def task_remaining_hour(task_id)
  	
  	if task_id.present?  		
  		used_time=TimeEntry.where("task_id=?",task_id).sum(:hours)
  		total_time = Task.find(task_id).estimated_time
	  	if total_time.present?
	  		avaliable_time =  total_time - used_time
	  	else
	  		return avaliable_time = nil
	  	end
  	else
  		avaliable_time=nil
  	end
  	return avaliable_time 		
  	
  end
end
