class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Usuario.new

    if user.admin?
      can :manage, :all
    end

    if user.waitress?
      can [:show, :edit, :update, :propinas], Corte
      can :index, :tablero
      can :manage, Asistencia
      can :manage, Comanda
      can :manage, Gasto
    end

    if user.manager?
      can :manage, Articulo
      can :manage, Desechable
      can :manage, Mesero
    end

    can :manage, Sesion 
  end
end
