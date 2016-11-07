class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    roles = Array.new
    user.roles.each do |r|
      roles << r.id
    end
    if roles.include? 1
     can :create, TimeEntry
     can :user_account, :edit, :update, User
    end
    if roles.include? 2
     can :manage, TimeEntry
     can :manage, Task
     can :read, :edit, :update, Project
    end
    if roles.include? 3
      can :manage, TimeEntry
      can :manage, Project
      can :read, :edit, :update, Customer
    end
    if roles.include? 4
     can :crud, :all
     can :admin, User
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
