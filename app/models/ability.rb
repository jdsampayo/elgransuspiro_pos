class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    unless user.email.blank?
      can :manage, :all
    end

    can :manage, Sesion
  end
end
