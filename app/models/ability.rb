class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    unless user.email.blank?
      can :manage, :all
    end

    if Rails.env.development?
      can :manage, Sesion
      can [:edit, :update, :propinas], Corte
    end
  end
end
