class ApprovalMailer < ActionMailer::Base

  def mail_to_manager(week, user)
    te = TimeEntry.where("week_id = ? AND user_id = ? and project_id IS NOT NULL", week.id, week.user_id).first
    @manager = User.find(Project.find(te.project_id).user_id).email
    # manager = User.find(ad).email

    @week = week
    @sender = user.email

    mail(to: @manager , subject:"Time sheed submitted for approval" , from: @sender )

  end

  def mail_to_user(week, user)
    @user = User.find(week.user_id).email
    @approver = user.email

    @time = week

    mail(to:@user  , subject:"Timesheet Approval" , from:@approver)

  end
end