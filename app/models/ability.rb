class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    if user.manager?
      can :manage, :all
    end

    if user.waitress?
      can :manage, Sesion
      can [:show, :edit, :update, :propinas], Corte
      can :index, :tablero
      can :manage, Asistencia
      can :manage, Comanda
      can :manage, Gasto
      can :manage, Articulo
      can :manage, Desechable
      can :manage, Mesero
    end
  end
end
