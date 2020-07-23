class ApplicationController < ActionController::Base
  add_flash_types :info, :success, :warning, :danger
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user, :current_corte
  rescue_from ActiveRecord::RecordNotFound, with: :not_found

  private
  def not_found(exception)
    respond_to do |format|
      format.json { render json: {error: exception.message}, status: :not_found }
      format.any { render text: "Error: #{exception.message}", status: :not_found }
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = Sesion.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.usuario
  end

  def current_corte
    @corte = params[:corte_id].present? ? Corte.find(params[:corte_id]) : Corte.actual

    if @corte.blank?
      if Corte.first.abierto?
        redirect_to edit_corte_path(Corte.first)
      else
        @corte = Corte.create(dia: Time.now, inicial: Corte.first.siguiente_dia)
      end
    end

    @corte
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to acceso_denegado_path
    else
      redirect_to login_path
    end
  end
end
