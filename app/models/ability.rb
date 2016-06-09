class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:update], User, id: user.id
      can [:show], User
    else
      can :manage, Project, manager_id: user.id
      can :manage, Sprint
      can :manage, User
      can :manage, WorkPerformance
      can :manage, Phase
    end
  end
end
