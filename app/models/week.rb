class Week < ApplicationRecord
  has_many :time_entries, -> {order(:date_of_activity)}
  has_many :user_week_statuses
  accepts_nested_attributes_for :time_entries, allow_destroy: true, reject_if: proc { |time_entries| time_entries[:date_of_activity].blank? }
  has_many :upload_timesheets
  has_many :expense_records
  has_many :archived_weeks
  accepts_nested_attributes_for :upload_timesheets
  #mount_uploader :time_sheet, TimeSheetUploader
  EXPENSE_TYPE = ["Travel", "Stay","Food", "Gas", "Misc"]
  #before_update :something 


  def self.current_user_time_entries(current_user)
    logger.debug "Week - current_user_time_entries entering"
    TimeEntry.where(week_id: id, user_id: current_user.id).take
    logger.debug "Week - current_user_time_entries leaving"
  end
  
  def self.left_join_weeks(some_user, status)
    weeks = Week.arel_table
    user_week_statuses = UserWeekStatus.arel_table

    weeks = weeks.join(user_week_statuses, Arel::Nodes::OuterJoin).
                  on(weeks[:id].eq(user_week_statuses[:week_id]), user_week_statuses[:user_id].eq(some_user)).
                  join_sources
                   
    joins(weeks)
  end

  def self.something(data, user, week)
    #Compare the exisiting TimeEnteries to the new
      #If there are matching enteries, remove them
    logger.debug("data #{data} ")
      cte = TimeEntry.where(:week_id => week)
      current_values_array = []
      current_hash = {}

      cte.each_with_index do |x, i|
        #logger.debug("Current Index #{i}")
        current_hr = x.hours
        current_pr =x.partial_day
        current_vc_id= x.vacation_type_id

        if current_hr != nil && current_pr == "true" && current_vc_id != nil
          #logger.debug("Partial Day")
          current_hr = 8 - current_hr.to_i
        elsif current_hr != nil && (current_pr == nil||"false") && current_vc_id == nil
          #logger.debug ("Actual Work Day")
        elsif current_hr == nil && current_pr == "false" && current_vc_id != nil
         # logger.debug("Full Day Save")
        else
          logger.debug("lord have mercy on my soul")
        end
        current_values_array.push(current_hr,current_pr, current_vc_id)

        current_hash[i] = current_values_array
        current_values_array =[]
        logger.debug("Current_DB VALUES #{current_hash}")
      end 

    @user = user
    data = data.to_h
    logger.debug("my user #{@user}")
    meoHash = {}
    littleArray = []
    data.each do |key, value |

        #logger.debug("Index #{key} ARRAY::::: Hours:#{value["hours"]} Partial:#{value["partial_day"]} VC_ID: #{value["vacation_type_id"]}")

   
      hr = value["hours"] 
      pr = value["partial_day"]
      vc_id = value["vacation_type_id"]
        if hr != nil && pr == "true" && vc_id != nil
          #logger.debug("Partial Day")
          hr = 8 - hr.to_i
        elsif hr != nil && pr == nil && vc_id == ""
          #logger.debug ("Actual Work Day")
            hr = hr.to_i
        elsif vc_id != nil && pr == nil 
          #ogger.debug("Full Day Vacation REQUEST")
          hr = 8
        elsif (hr == nil||0) && pr == nil && vc_id == nil
          #logger.debug("Full Day Save")
        else
          logger.debug("lord have mercy on my soul")
        end
      littleArray.push(hr)
      littleArray.push(pr)
      littleArray.push(vc_id.to_i)
      #logger.debug("my little #{littleArray}")
      meoHash[key.to_i] = littleArray 
      littleArray = []
      logger.debug("Requested Values #{meoHash}")
    end 

#After the comparison is done, then run the following method


##Build an array that only shows requested values. So values that are not the same in the requested compared to the current_db values
      array_to_eval = {}
      meoHash.each_with_index do |value,i|
            logger.debug(" I am Comparing #{meoHash[i]} to  #{current_hash[i]}")

          if meoHash[i] == current_hash[i] 
              logger.debug("Do nothing")
          elsif meoHash[i] != current_hash[i] && meoHash[i][2] != 0

                logger.debug ("add this value #{meoHash[i]}")
            array_to_eval[i]= meoHash[i]
          end
          logger.debug("Hash to Eval... #{array_to_eval} ")
      end
#####

     #weekEntry = params[:bigArray]
        new_h = {}
        array_to_eval.each do |key, val|
          x1 = val[1]
          x2 = val[2]
          found = false
          new_h.each do |key1, val2|
            #y1 = val2[1]
            y2 = val2[2]
            #if x1 === y1 && x2 === y2
            if  x2 ===  y2
              found = true
              arr = [val2[0].to_i + val[0].to_i, x1, x2]
              new_h[key1] = arr
            end
          end
          if !found
            new_h[new_h.length] = val
          end
          if new_h.empty?
            new_h[key] = val
          end
        end

        logger.debug( "Array Merge #{new_h}")

        new_h.each do |key, array|  ### ITERATION
            logger.debug("Index #{key} ARRAY::::: Hours:#{array[0]} Partial:#{array[1]} VC_ID: #{array[2]}")
              #hours_worked = array[0]
              hours_requested = array[0]
              partial_day = array[1]
              vacation_id = array[2]
              logger.debug("WHAT DOES THIS SAY?! #{vacation_id.present?}")

          if vacation_id.present? 
            @vacation_type = VacationType.find(vacation_id)
            uvt = VacationRequest.where("vacation_type_id=? and user_id=?", vacation_id , @user )
            logger.debug("Num Of VcRqst #{uvt.length}")
    ################# HOURS_ALLOWED/Accural Logic 
              if (@vacation_type.accrual == true && uvt.length > 0 )
                    logger.debug(" A =TRUE && UVT != 0")
                  #Total Days Used Logic
                    total_used = []
                    uvt.each do |x|
                      if x.hours_used != nil
                      total_used.push(x.hours_used)
                       end 
                    end
                    logger.debug("Total Hours Used #{total_used}")
                    total_hours_used = total_used.inject :+  #Important
                    #Accural Logic(!First) 
                        today = Date.today.strftime('%m').to_f
                        user_start_date = @user.invitation_start_date.strftime('%m').to_f
                        months_at_job = today - user_start_date
                        hour_rate = @vacation_type.vacation_bank.to_f * 0.667 #8hr/12months
                      current_hours_allowed = hour_rate * months_at_job #This changes***
                      logger.debug("current days allowed #{current_hours_allowed} Total hours Used #{total_hours_used}")
                      hours_allowed = current_hours_allowed - total_hours_used 
                      logger.debug("Hours allowed #{hours_allowed}")

              elsif (@vacation_type.accrual == true && uvt.length <= 0)
                  logger.debug(" A =TRUE && UVT is 0")
                  #Accural Logic(First) 
                  today = Date.today.strftime('%m').to_f
                  user_start_date = @user.invitation_start_date.strftime('%m').to_f
                  months_at_job = today - user_start_date
                  hour_rate = @vacation_type.vacation_bank.to_f * 0.667 #8hr/12months
                  hours_allowed = hour_rate * months_at_job  

              elsif (@vacation_type.accrual == false && uvt.length > 0)
                  logger.debug(" A != FALSE && UVT != 0")
                      total_used = []
                      uvt.each do |x|
                        total_used.push(x.hours_used)
                      end
                      total_hours_used = total_used.inject :+
                    vb  = @vacation_type.vacation_bank * 8 #VB is in days!
                    hours_allowed = vb.to_f - total_hours_used
                    logger.debug(" VB Hours #{vb} and total_hours_used is #{total_hours_used}")
              elsif (@vacation_type.accrual == false && uvt.length <= 0)
                logger.debug(" A = FALSE && UVT = 0")
                      hours_allowed = @vacation_type.vacation_bank * 8
              else
                  logger.debug("$$$$$$$$   something went WRONGGGGGGG !!!!!!!")
              end #end days_allowed 
              logger.debug("hours_allowed #{hours_allowed} and hours requested #{hours_requested}")
              ############### should be >

                if hours_requested.to_f < hours_allowed.to_f
                  logger.debug("Vacation Request Does Not Have The Hours")
                  #errors.add(:base, "cant be saved because of reason x,y,z")
                  #throw :abort
                  smash = { vacation_valid: false, hours_requested: hours_requested, hours_allowed: hours_allowed }
                  return smash 

                else
                  logger.debug("Vacation Request Valid")
                  smash = { vacation_valid: true, hours_requested: hours_requested, hours_allowed: hours_allowed }
                  return smash 
                  
                end 
          end #if vacation.id present?
           logger.debug("THIS IS THE END OF THE ITERATION THIS IS THE END OF THE ITERATION THIS IS THE END OF THE ITERATION ")   
        end### End Iteration
  end 

  def self.left_joins_user_week_statuses(some_user, week_id)
    weeks = Week.where("weeks.id = ?", week_id).weeks_with_user_week_statuses(some_user)
  end

  def self.weeks_with_invitation_start_date(user)
      next_week_start_date = Date.today.beginning_of_week + 7.days
      user_invite_start_date = user.invitation_start_date.beginning_of_week 

      until user_invite_start_date == next_week_start_date
        new_week = Week.where(user_id: user.id, start_date: user_invite_start_date).last
        if new_week.blank?
          new_week = Week.new
          new_week.start_date = user_invite_start_date
          new_week.end_date = user_invite_start_date.to_date.end_of_week.strftime('%Y-%m-%d') 
          new_week.user_id = user.id
          new_week.status_id = 1
          new_week.save
        end

        7.times { new_week.time_entries.build( user_id: user.id )}
        new_week.time_entries.each_with_index do | te, i |
          new_week.time_entries[i].date_of_activity = Date.new(new_week.start_date.year, new_week.start_date.month, new_week.start_date.day) + i
          new_week.time_entries[i].user_id = user.id
        end
        new_week.save
        user_invite_start_date += 7.days
      end
  end

  def copy_week(current_time_entries, pre_week_time_entries)
    count = 0
    current_time_entries.each do |t|
       
     Rails.logger.debug("#{count}")
     Rails.logger.debug("NEW WEEKS DATE OF ACTIVITY: #{t.date_of_activity}")
     Rails.logger.debug("OLD WEEKS DATE OF ACTIVITY: #{pre_week_time_entries[count].date_of_activity}")
     Rails.logger.debug("HOURS to populate: #{pre_week_time_entries[count].hours}")
     Rails.logger.debug("OLD WEEKS PROJECT: #{pre_week_time_entries[count].project_id}")
     Rails.logger.debug("COPYING OLD WEEKS TASKS: #{pre_week_time_entries[count].task_id}")
     Rails.logger.debug("COPYING OLD WEEKS TIME-IN: #{pre_week_time_entries[count].time_in}")
     Rails.logger.debug("COPYING OLD WEEKS TIME-OUT: #{pre_week_time_entries[count].time_out}")
     Rails.logger.debug("COPYING DESCRIPTION: #{pre_week_time_entries[count].activity_log}")         
     Rails.logger.debug("COPYING SICK DAY: #{pre_week_time_entries[count].sick}")
     Rails.logger.debug("COPYING PERSONAL DAY: #{pre_week_time_entries[count].personal_day}")
     t.hours = pre_week_time_entries[count].hours
     t.project_id = pre_week_time_entries[count].project_id
     t.task_id = pre_week_time_entries[count].task_id
     t.time_in = pre_week_time_entries[count].time_in
     t.time_out = pre_week_time_entries[count].time_out
     t.activity_log = pre_week_time_entries[count].activity_log
     t.sick = pre_week_time_entries[count].sick
     t.personal_day = pre_week_time_entries[count].personal_day
     t.save

     count += 1
    end
  end
  
  def self.weekly_weeks
    User.send_timesheet_notification
    User.all.each do |u|
      user_week_end_date = Week.where(user_id: u.id, end_date: "#{Date.today.end_of_week.strftime('%Y-%m-%d')}")
      if user_week_end_date.blank?
        @week = Week.new
        @week.start_date = Date.today.beginning_of_week.strftime('%Y-%m-%d')
        @week.end_date = Date.today.end_of_week.strftime('%Y-%m-%d')
        @week.user_id = u.id
        @week.status_id = Status.find_by_status("NEW").id
        @week.save!
        7.times {  @week.time_entries.build( user_id: u.id )}
          
        @week.time_entries.each_with_index do |te, i|
          logger.debug "weeks_controller - edit now for each time_entry we need to set the date  and user_id and also set the hours  to 0"
          logger.debug "year: #{@week.start_date.year}, month: #{@week.start_date.month}, day: #{@week.start_date.day}"
          logger.debug "i #{i}"
          @week.time_entries[i].date_of_activity = Date.new(@week.start_date.year, @week.start_date.month, @week.start_date.day) + i
          @week.time_entries[i].user_id = u.id
        end
        @week.save!
      end
    end
    ###send time sheet notification
    #User.send_timesheet_notification
  end

  def copy_last_week_timesheet(user)

    current_week_start_date = self.start_date
    pre_week_start_date = current_week_start_date - 7.days
    logger.debug("CHECKING FOR USER : #{pre_week_start_date.inspect} , #{user.inspect}")
    pre_week = Week.where("user_id = ? && start_date = ?", user ,pre_week_start_date)
    logger.debug("CHECKING FOR PREVIOUS WEEK: #{pre_week.inspect}")
    #w = week.find(current_week_id)
    #w1 = Week.where(user_id: 1)[-2]
    #puts "previous week id is: #{w1.d}"
    #w2 = Week.where(user_id: current_user).last

    pre_week_time_entries = TimeEntry.where(week_id: pre_week[0].id)

    current_time_entries = TimeEntry.where(week_id: self.id)
    count = 0
    if pre_week_time_entries.count == 7
      logger.debug("WEEK WITH 7 TIME ENTRIES")
      copy_week(current_time_entries, pre_week_time_entries)
      
    else
      if pre_week_time_entries.count != current_time_entries.count
        day_array = []
        pre_week_time_entries.each do |t|
          day = t.date_of_activity.strftime("%A")
          logger.debug("THE DAY IS: #{day}")
          day_array << day
        end
        dup_days = day_array.select{|d| day_array.count(d)>1}.uniq
        logger.debug("THE DAY ARRAY IS: #{dup_days.inspect}")

        dup_days.each do |dd|
          logger.debug("THE DAY IS: #{dd}")
          num_of_repetition = day_array.count(dd)
          logger.debug("num_of_repetition is :#{num_of_repetition}")

          current_time_entries.each do |cwte|
            if cwte.date_of_activity.strftime("%A") == dd
              date = cwte.date_of_activity
              logger.debug("CHECKING FOR DATE #{date.inspect}")
              (num_of_repetition - 1).times{
                t = TimeEntry.new
                t.week_id = self.id
                t.date_of_activity = date
                t.save
              }
            end
          end
        end
      end 
      current_time_entries_1 = TimeEntry.where(week_id: self.id)
      copy_week(current_time_entries_1, pre_week_time_entries)
      logger.debug("CHECKING FOR CODE")
    end 
  end

    def clear_current_week_timesheet
      logger.debug("CLEAR WEEK ============================ #{self.inspect}")
      time_entries = self.time_entries
      logger.debug("TIME ENTRIES TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT #{time_entries.inspect}")
      time_entries.each do |t|
        t.hours = nil
        t.activity_log = nil
        t.status_id = 1
        t.save
      end

  
    end 
end
