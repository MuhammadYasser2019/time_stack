class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    if user.user
      can [:new, :create, :update], TimeEntry
      can [:user_account, :edit, :update, :show_user_reports, :user_profile, 
           :user_notification, :set_default_project, :user_notification_date, 
           :get_notification, :show_user_weekly_reports, :manage_profiles, 
           :invite_sub_users, :login_user, :assign_project, :single_vacation_request, :get_user_projects], User
      can [:read, :available_tasks], Task
      can [:read, :edit, :create, :update, :new, :report, :copy_timesheet, :clear_timesheet, :previous_comments, :add_previous_comments, :expense_records, :delete_expense], Week
      can [:read, :permission_denied, :show_old_timesheets], Project
      can [:vacation_request, :pre_vacation_request, :cancel_vacation_request], Customer
      can [:single_vacation_request], Week

      if user.admin
       can :crud, :all
       can :read, :all
       can :manage, User
       can :manage, Week
       can :manage, Customer
       can :manage, Project
       can [:get_user_projects], :user
      end
      if user.cm
        can :manage, TimeEntry
        can [:read,:edit,:update], Task
        can [:manage, :permission_denied, :show_project_reports,:approve], Project
        can [:manage, :read,:edit,:update, :add_user_to_customer, :set_theme], Customer
	can [:time_reject, :dismiss, :show_all_timesheets, :change_status], Week
	can [:reset,:approved_week, :default_week], User
        can [:check_holidays], Holiday
      end
      if user.pm
       can :manage, TimeEntry
       can :manage, Task
       can [:manage, :read, :edit, :update,:show_hours, :permission_denied, :show_project_reports,:approve, :add_adhoc_pm, :dynamic_project_update], Project
       can [:new, :create, :edit, :update, :time_reject], Week
      end
      if user.proxy
        can [:proxies, :proxy_users, :enter_timesheets, :show_timesheet_dates, :add_proxy_row, :fill_timesheet], User
        can :proxy_week, Week
      end
     
    else
      can :permission_denied, Project
    end

    
    
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
