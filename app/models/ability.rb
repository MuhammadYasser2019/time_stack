class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    if user.user
      can [:new, :create, :update], TimeEntry
      can [:user_account, :edit, :update, :show_user_reports, :user_profile], User
      can [:read, :available_tasks], Task
      can [:read, :edit, :create, :update, :new, :report], Week
      can [:read, :permission_denied], Project
      can [:vacation_request], Customer

      if user.admin
       can :crud, :all
       can :read, :all
       can :manage, User
       can :manage, Week
       can :manage, Customer
      end
      if user.cm
        can :manage, TimeEntry
        can [:read,:edit,:update], Task
        can [:manage, :permission_denied, :show_project_reports,:approve], Project
        can [:read,:edit,:update, :add_user_to_customer, :set_theme], Customer
      end
      if user.pm || user.apm
       can :manage, TimeEntry
       can :manage, Task
       can [:read, :edit, :update,:show_hours, :permission_denied, :show_project_reports,:approve], Project
       can [:new, :create, :edit, :update], :update, Week
      end
      if user.proxy
        can [:proxies, :proxy_user], User
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
