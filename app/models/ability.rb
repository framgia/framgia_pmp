class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:update], User, id: user.id
      can [:show], User
      can :read, Project
      can [:read, :create, :update], WorkPerformance, assignee_id: user.id
      can :read, Sprint
    else
      can :manage, Project, manager_id: user.id
      can :manage, Sprint
      can :manage, User
      can :manage, WorkPerformance
      can :manage, Phase
      can [:update], User
      can :manage, ProductBacklog
    end
  end
end
