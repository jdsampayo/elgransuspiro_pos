class ApplicationController < ActionController::Base
  add_flash_types :info, :success, :warning, :danger
  protect_from_forgery with: :exception
  helper_method :current_user

  private

  def requiere_corte_actual
    redirect_to(
      edit_corte_path(Corte.order(dia: :desc).take),
      notice: "Para realizar la acción solicitada, por favor primero realiza el corte del día anterior."
    ) unless Corte.actual
  end

  def current_session
    return @current_session if @current_session
    @current_session = Sesion.find
  end

  def current_user
    @current_user = current_session && current_session.record
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to acceso_denegado_path
    else
      redirect_to login_path
    end
  end
end
