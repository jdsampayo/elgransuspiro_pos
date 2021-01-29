class ApplicationController < ActionController::Base
  add_flash_types :info, :success, :warning, :danger
  protect_from_forgery with: :exception
  helper_method :current_user_session, :current_user, :current_corte, :current_sucursal
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
    @corte = if params[:corte_id].present?
      if current_user.admin?
        Corte.find(params[:corte_id])
      else
        raise "Forbidden"
      end
    else
      Corte.actual(current_sucursal)
    end

    if @corte.blank?
      corte_sucursal = Corte.de_la_sucursal(current_sucursal).last
      if corte_sucursal&.abierto?
        redirect_to edit_corte_path(corte_sucursal)
      else
        @corte = Corte.create_next(current_sucursal)
      end
    end

    @corte
  end

  def current_sucursal
    if cookies[:sucursal]
      Sucursal.where(nombre: cookies[:sucursal]).take
    else
      raise "No current sucursal defined"
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    if current_user
      redirect_to acceso_denegado_path
    else
      redirect_to login_path
    end
  end
end
