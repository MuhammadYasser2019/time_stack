class UserDevice < ApplicationRecord
    has_one :user

    def self.save_device_information(user_id, device_id, platform, device_name,token)
        @user_device = UserDevice.where(:device_id => device_id, :user_id => user_id).first                

        if @user_device.nil?
            @user_device = UserDevice.new
            @user_device.user_id = user_id
            @user_device.device_id = device_id
            @user_device.user_token = token
            @user_device.platform = platform
            @user_device.save
        else
            @user_device.user_token = token
            @user_device.save
        end
      
        UserDevice.where("user_id != ? AND device_id=?",user_id,device_id).update_all(user_token: nil)
    end

    def self.send_shift_notification
        # GET ALL USER whose shift is starting or ending. If the user have not filled their time entry then fetch their token from the database and finally generate a message to send to the users. Make sure not to send the notification twice for the same entry.

        @start_time = Time.now
        # @start_time = "9:42 AM".to_time
        @end_time = @start_time + 15 * 60 #15 min later

        @shift_ids = []

        @shifts = Shift.select(:start_time,:end_time,:id)

        @shifts.map do |s|
            between_start = s.start_time>@start_time && s.start_time<@end_time
            between_end = s.end_time>@start_time && s.end_time<@end_time
            if(between_start || between_end)
                @shift_ids.push(s.id)
            end
        end

        @project_shift_ids = ProjectShift.where(:id=>@shift_ids).pluck(:id)

        @shift_projects = ProjectsUser.where(:project_shift_id=> @project_shift_ids).joins(:user, :project).select("users.id as user_id,projects.id as project_id, projects.name").as_json

        @user_ids = []

        @shift_projects.map do |i|
             @user_ids.push(i["user_id"]) 
        end
        @user_ids.uniq

        @token_info = TimeEntry.where(:user_id=> @user_ids).where("DATE(date_of_activity)='#{Date.today}'").joins(:user=> :user_devices).select("time_entries.id as entry_id, week_id, users.id as user_id, user_devices.user_token as user_token").as_json

        @push_messages = []

        @token_info.map do |ti|
            cur_user_id = ti["user_id"]
            token = ti["user_token"]
            entry_id = ti["entry_id"]
            week_id = ti["week_id"]

            projects = []
                    
            @shift_projects.select{|i| i["user_id"] == cur_user_id}.map do |p|
                projects.push({id: p["project_id"], name: p["name"]})
            end
            projects.uniq

            projects.map do |p|
                @push_messages.push({
                    to: token,
                    title:"Timesheet Reminder - #{p[:name]}",
                    sound: "default",
                    data: {entryID: entry_id, weekID: week_id, projectID: p[:project_id], userID: cur_user_id},
                    body: "Are you ready to fill your time sheet for the day?"
                })
            end
        end
        UserDevice.handle_push_notifications(@push_messages)
    end

    private 

    def self.handle_push_notifications(messages)  
        # MAX 100 messages at a time
        if !messages.nil?
            # TODO: ALLOW MULTIPLE MESSAGES, ALSO SLICE 100 at a TIME
            max_messages = 100
            while messages.count>0 do
                messages_to_process = messages.first(max_messages)
                UserDevice.send_push_notification(messages_to_process)
                messages = messages.drop(max_messages)
            end
        end
    end

    def self.send_push_notification(messages)
        client = Exponent::Push::Client.new

        # MAX 100 messages at a time
        handler = client.publish(messages)

        # Array of all errors returned from the API
        # puts handler.errors

        # you probably want to delay calling this because the service might take a few moments to send
        # client.verify_deliveries(handler.receipt_ids)
    end
end
  