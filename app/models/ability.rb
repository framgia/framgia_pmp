class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    if user.member?
      can [:show, :update], User, id: user.id
    else
      can :manage, Project
      can :manage, Sprint
      can :manage, User
    end
  end
end
