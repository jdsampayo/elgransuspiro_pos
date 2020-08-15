class Ability
  include CanCan::Ability

  def initialize(user)
    alias_action :new, :create, :edit, :update, :destroy, to: :pos

    user ||= Usuario.new

    if user.admin?
      can :manage, :all
      cannot :pos, Comanda
      cannot :pos, Gasto
      cannot :pos, Corte
      cannot :pos, Asistencia
    end

    if user.waitress?
      can [:show, :edit, :update, :propinas], Corte
      can :index, :tablero
      can :manage, Asistencia
      can :manage, Comanda
      can :manage, Gasto
      can [:index, :set], Sucursal
    end

    if user.manager?
      can :manage, Articulo
      can :manage, Desechable
      can :manage, Mesero
    end

    can :manage, Sesion 
  end
end
